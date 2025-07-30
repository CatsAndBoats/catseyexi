#pragma once

#include <chrono>
#include <fmt/color.h>
#include <fmt/format.h>
#include <optional>
#include <string>
#include <vector>

// This error reporting is structured to fit the JUnit XML format.

using test_clock    = std::chrono::high_resolution_clock;
using test_duration = std::chrono::duration<float>;

namespace ColoredMessages
{
    const auto SKIP = fmt::format(fmt::fg(fmt::terminal_color::bright_black) | fmt::emphasis::bold, "SKIP");
    const auto PASS = fmt::format(fmt::fg(fmt::terminal_color::green) | fmt::emphasis::bold, "PASS");
    const auto FAIL = fmt::format(fmt::fg(fmt::terminal_color::red) | fmt::emphasis::bold, "FAIL");
}

struct FailDescription
{
    std::string message;
    std::string type;
};

class TestCase
{
public:
    // Attributes
    std::string name;
    std::string classname;
    test_duration time = 0s;

    // Elements
    std::optional<std::string> skipped;
    std::optional<FailDescription> error;
    std::vector<FailDescription> failures;

    TestCase(std::string _name, std::string _classname)
    : name(_name)
    , classname(_classname) {};

    friend std::ostream& operator<<(std::ostream& os, const TestCase& testcase)
    {
        os << "  ";
        bool isSuccess = true;

        if (testcase.skipped.has_value())
        {
            os << "[" << ColoredMessages::SKIP << "]";
        }
        else if (!testcase.error.has_value() && testcase.failures.empty())
        {
            os << "[" << ColoredMessages::PASS << "]";
        }
        else
        {
            os << "[" << ColoredMessages::FAIL << "]";
        }
        os << fmt::format(" {}{} ({}ms)", testcase.classname, testcase.name, std::chrono::duration_cast<std::chrono::milliseconds>(testcase.time).count());

        if (testcase.skipped.has_value())
        {
            os << fmt::format(" [Skip reason: {}]", testcase.skipped.value());
        }
        else if (testcase.error.has_value())
        {
            os << std::endl
               << fmt::format(fmt::fg(fmt::terminal_color::yellow), "[Error type: {}]\n{}", testcase.error.value().type, testcase.error.value().message);
        }

        if (!testcase.failures.empty())
        {
            for (auto&& failure : testcase.failures)
            {
                os << std::endl
                   << fmt::format(fmt::fg(fmt::terminal_color::yellow), "[Failure type: {}] {}", failure.type, failure.message);
            }
        }

        os << std::endl;
        return os;
    }
};

class TestSuite
{
public:
    // Attributes
    std::string name;
    test_clock::time_point timestamp = test_clock::now();

    std::string hostname = "localhost";

    // Elements
    std::vector<TestCase> testcases;

    std::string system_out;
    std::string system_err;

    TestSuite(std::string _name)
    : name(_name) {};

    void preOutput(std::ostream& os)
    {
        os << std::endl
           << fmt::format(fmt::emphasis::bold, "{}", this->name) << ":" << std::endl;
    }

    void postOutput(std::ostream& os)
    {
        if (!this->system_err.empty())
        {
            os << fmt::format(fmt::fg(fmt::terminal_color::yellow), "========================================") << std::endl;
            os << fmt::format(fmt::fg(fmt::terminal_color::yellow), "Error output:") << std::endl;
            os << this->system_err << std::endl;
            os << fmt::format(fmt::fg(fmt::terminal_color::yellow), "========================================") << std::endl;
        }
        os << std::endl;
    }
};

class ErrorReport
{
public:
    std::string name;

    std::vector<TestSuite> testsuites;

    ErrorReport(std::string _name)
    : name(_name) {};

    void postOutput(std::ostream& os)
    {
        std::vector<std::string> highlights;
        uint32 successes        = 0;
        uint32 falures          = 0;
        uint32 errors           = 0;
        uint32 skipped          = 0;
        test_duration totalTime = 0s;
        for (auto&& testsuite : this->testsuites)
        {
            for (auto&& testcase : testsuite.testcases)
            {
                totalTime += testcase.time;
                if (testcase.error.has_value() || !testcase.failures.empty())
                {
                    if (testcase.error.has_value())
                    {
                        errors++;
                    }
                    else
                    {
                        falures++;
                    }

                    std::stringstream buffer;
                    buffer << testsuite.name << " - ";
                    buffer << testcase;
                    highlights.push_back(buffer.str());
                }
                else if (testcase.skipped.has_value())
                {
                    skipped++;
                }
                else
                {
                    successes++;
                }
            }
        }

        os << "--------------------------------------------------------------------------------" << std::endl;
        os << fmt::format(fmt::emphasis::bold, "Summary:") << std::endl;
        os << fmt::format(fmt::emphasis::bold, "Successes: {}, Failures: {}, Errors: {}, Skipped: {}.", successes, falures, errors, skipped) << std::endl;
        os << fmt::format(fmt::emphasis::bold, "Total time taken: {:.1f}s", totalTime.count()) << std::endl;

        if (!highlights.empty())
        {
            os << std::endl;
            os << fmt::format(fmt::fg(fmt::terminal_color::red) | fmt::emphasis::bold, "ERRORS:") << std::endl;
            for (auto&& highlight : highlights)
            {
                os << highlight;
            }
        }

        os << "--------------------------------------------------------------------------------" << std::endl;
        os << std::endl;
    }
};
