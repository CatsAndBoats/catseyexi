#include "memory_sink.h"

memory_sink::memory_sink(OutputLogs& _output)
: output(_output)
{
}

memory_sink::~memory_sink()
{
    output.clear();
}

void memory_sink::sink_it_(const spdlog::details::log_msg& msg)
{
    auto logTypeIter = logging::LoggerMap.find(msg.logger_name.data());
    if (logTypeIter == logging::LoggerMap.end())
    {
        return;
    }

    bool isError = false;
    switch (logTypeIter->second)
    {
    case LogType::Error:
    case LogType::FatalError:
        isError = true;
        break;
    default:
        break;
    };

    output[isError].push_back(msg.payload.data());
}

void memory_sink::flush_()
{
}
