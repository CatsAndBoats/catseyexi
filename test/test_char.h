#pragma once

#include <memory>

struct game_session_data_t;

class TestChar
{
public:
    static std::unique_ptr<TestChar> create(uint8 zoneId = 240);
    static void cleanAll();

    ~TestChar();

    uint32 accountId = 0;
    uint32 charId    = 0;
    uint64 ipp       = 0;

    game_session_data_t* session = nullptr;
};
