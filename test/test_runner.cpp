#include <argparse/argparse.hpp>
#include <sol/sol.hpp>

#include "game/filereload.h"
#include "game/lua/luautils.h"
#include "game/utils/zoneutils.h"
#include "game/zone.h"

#include "memory_sink.h"
#include "reporting/report.h"

#include "lua_sim_client.h"
#include "lua_simulation.h"
#include "test_char.h"

OutputLogs logs;

void init(bool withStdout)
{
    std::cout << "Initializing..." << std::endl;
    logging::init("", withStdout);

    logging::addSink(std::make_shared<memory_sink>(logs));
    Config::loadConfig("common.yml", common_config, true);

    game_config.isTestServer = true;
    game_config.dynamicZones = true;
    game_config.lazyMeshLoad = true;

    game_config.disableLosLoad    = true;
    game_config.controlledWeather = true;

    GameEngine::initialize();

    TestChar::cleanAll();

    CLuaSimulation::SolRegister(luautils::lua);
    CLuaSimClient::SolRegister(luautils::lua);

    filereload::addHandler("test/scripts", [&](fs::path path)
        {
            luautils::lua.safe_script_file(path.string());
        });

    std::cout << "Done initializing." << std::endl;
}

bool stringContains(const std::string& haystack, std::optional<std::string> needle)
{
    if (!needle.has_value())
    {
        return true;
    }

    auto it = std::search(
        haystack.begin(), haystack.end(), needle.value().begin(), needle.value().end(), [](char ch1, char ch2)
        {
            return std::tolower(ch1) == std::tolower(ch2);
        });
    return (it != haystack.end());
}

int run(std::optional<std::string> filter, bool runSkip)
{
    // TODO: more advanced filtering instead of matching 1:1
    filereload::handle();

    auto wrapperObj = luautils::lua.safe_script_file("test/scripts/test_wrapper.lua");
    if (!wrapperObj.valid())
    {
        sol::error err = wrapperObj;
        std::cerr << err.what() << std::endl;
        return 1;
    }

    sol::protected_function wrapper = wrapperObj;

    ErrorReport report = ErrorReport("Report");

    for (const auto& dirEntry : fs::recursive_directory_iterator("test/scripts/tests"))
    {
        if (dirEntry.is_regular_file() && dirEntry.path().extension() == ".lua")
        {
            zoneutils::ForEachZone([](CZone* zone)
                {
                    zone->SleepIfEmpty();
                });

            logs.clear();

            auto dirEntryStr = dirEntry.path().lexically_normal().string();
            bool runAll      = filter.has_value() ? stringContains(dirEntry.path().filename().string(), filter.value()) : true;

            TestSuite suite = TestSuite(dirEntryStr);

            auto res = luautils::lua.safe_script_file(dirEntryStr);

            if (!res.valid())
            {
                sol::error err   = res;
                suite.system_err = err.what();
                report.testsuites.push_back(std::move(suite));
                continue;
            }

            CLuaSimulation simulation;

            bool didPrintSuite = false;
            sol::object resObj = res;

            if (resObj.is<sol::table>())
            {
                sol::table luaSuite = resObj;

                auto suitePre = [&didPrintSuite, &suite]()
                {
                    if (!didPrintSuite)
                    {
                        suite.preOutput(std::cout);
                        didPrintSuite = true;
                    }
                };

                std::unordered_map<std::string, std::string> skipCases;
                if (!runSkip)
                {
                    sol::object skipCaseObj = luaSuite["_skip"];
                    if (skipCaseObj.is<sol::table>())
                    {
                        sol::table skipCaseTable = skipCaseObj;
                        for (auto&& caseName : skipCaseTable)
                        {
                            skipCases.emplace(caseName.first.as<std::string>(), caseName.second.as<std::string>());
                        }
                    }
                }

                for (auto&& test : luaSuite)
                {
                    auto caseName = test.first.as<std::string>();
                    if (caseName == "_skip" || (!runAll && filter.has_value() && !stringContains(caseName, filter.value())))
                    {
                        continue;
                    }

                    suitePre();

                    TestCase testcase = TestCase(caseName, "");
                    if (auto skipReason = skipCases.find(caseName); skipReason != skipCases.end())
                    {
                        testcase.skipped = { skipReason->second };
                    }
                    else
                    {
                        auto start    = test_clock::now();
                        auto res      = wrapper(simulation, test.second);
                        testcase.time = test_clock::now() - start;

                        if (!res.valid())
                        {
                            sol::error error = res;
                            testcase.error   = std::make_optional<FailDescription>(FailDescription {
                                error.what(),
                                "assert",
                            });
                        }

                        simulation.clean();
                        luautils::garbageCollect();

                        if (!logs[true].empty())
                        {
                            testcase.failures.push_back(FailDescription { fmt::format("{}", fmt::join(logs[true], "\n")), "error-log" });
                            logs[true].clear();
                        }
                    }

                    std::cout << testcase;
                    suite.testcases.push_back(std::move(testcase));

                    simulation.clean();
                }
            }

            if (!suite.testcases.empty() || !logs[true].empty())
            {
                suite.system_out = fmt::format("{}", fmt::join(logs[false], "\n"));
                suite.system_err = fmt::format("{}", fmt::join(logs[true], "\n"));

                if (didPrintSuite)
                {
                    suite.postOutput(std::cout);
                }
                report.testsuites.push_back(std::move(suite));
            }
        }
    }

    report.postOutput(std::cout);

    // Return non-zero if any errors were encountered.
    for (auto&& testsuite : report.testsuites)
    {
        if (!testsuite.system_err.empty())
        {
            return 1;
        }
        for (auto&& testcase : testsuite.testcases)
        {
            if (testcase.error.has_value() || !testcase.failures.empty())
            {
                return 1;
            }
        }
    }

    return 0;
}

void do_final(int code)
{
    delete engine;
    exit(code);
}

int main(int argc, char** argv)
{
    argparse::ArgumentParser program("test_runner");
    program.add_argument("filter")
        .default_value(std::string(""))
        .help("Term used to filter tests. Matches against file names and testcase names.");

    program.add_argument("-a", "--all")
        .default_value(false)
        .implicit_value(true)
        .help("Specify to run all tests once and finish the program.");

    program.add_argument("-o", "--output")
        .default_value(false)
        .implicit_value(true)
        .help("Supply to allow logging to be put output to the console.");

    program.add_argument("-rs", "--run-skip")
        .default_value(false)
        .implicit_value(true)
        .help("Run test cases that are normally skipped.");

    try
    {
        program.parse_args(argc, argv);
    }
    catch (const std::runtime_error& err)
    {
        std::cerr << err.what() << std::endl;
        std::cerr << program;
        std::exit(1);
    }

    std::optional<std::string> filterArg = std::nullopt;

    auto filter = program.get<std::string>("filter");
    if (!filter.empty())
    {
        filterArg = { filter };
    }

    auto run_skip = program.get<bool>("run-skip");

    init(program.get<bool>("output"));
    if (program.get<bool>("all"))
    {
        auto result = run(filterArg, run_skip);
        do_final(result);
        return result;
    }

    std::string input = "";
    if (!filterArg.has_value())
    {
        std::cout << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "Input options:") << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "  - Press ENTER to run all tests") << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "  - Input a string to filter tests by") << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "  - 'q' to exit") << std::endl;

        getline(std::cin, input);
        std::cout << std::endl;

        if (!input.empty())
        {
            filterArg = { input };
        }
    }

    while (input != "q")
    {
        if (filterArg.has_value())
        {
            std::cout << fmt::format("Filter: '{}'", filterArg.value().c_str()) << std::endl;
        }
        std::cout << "--------------------------------------------------------------------------------" << std::endl;
        run(filterArg, run_skip);

        std::cout << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "Input options:") << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "  - Press ENTER to re-run the same tests") << std::endl;
        std::cout << fmt::format(fmt::emphasis::bold, "  - Input a string to filter tests by") << std::endl;
        if (filterArg.has_value())
        {
            std::cout << fmt::format(fmt::emphasis::bold, "  - '#' to run all tests") << std::endl;
        }
        std::cout << fmt::format(fmt::emphasis::bold, "  - 'q' to exit") << std::endl;

        getline(std::cin, input);
        std::cout << std::endl;

        if (input == "q")
        {
            break;
        }
        else if (input == "#")
        {
            filterArg = std::nullopt;
        }
        else if (!input.empty())
        {
            filterArg = { input };
        }
    }

    do_final(0);
    return 0;
}
