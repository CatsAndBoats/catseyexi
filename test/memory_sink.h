#pragma once


#include <spdlog/spdlog.h>
#include <unordered_map>

using OutputLogs = std::unordered_map<bool, std::vector<std::string>>;

class memory_sink : public spdlog::sinks::base_sink<std::mutex>
{
public:
    memory_sink(OutputLogs& output);
    ~memory_sink();

private:
    OutputLogs& output;

protected:
    void sink_it_(const spdlog::details::log_msg& msg) override;
    void flush_() override;
};
