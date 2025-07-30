
#include "test_char.h"

#include "../src/game/entities/charentity.h"

// Can use IDs higher than 24 bits, since that's the maximum supported by the login server and client.
#define MIN_TEST_ACC_ID  (uint32)20'000'000
#define MIN_TEST_CHAR_ID (uint32)20'000'000

std::unique_ptr<TestChar> TestChar::create(uint8 zoneId)
{
    const char* query;

    query = "SELECT max(id) FROM accounts";
    if (Sql_Query(SqlHandle, query) == SQL_ERROR || Sql_NumRows(SqlHandle) == 0 || Sql_NextRow(SqlHandle) != SQL_SUCCESS)
    {
        std::cerr << "Unable to get max accounts ID" << std::endl;
        return nullptr;
    }
    auto accId = std::max(MIN_TEST_ACC_ID, (uint32)Sql_GetUIntData(SqlHandle, 0) + 1);

    auto accountName = "TEST_account_" + std::to_string(accId);
    query            = "INSERT INTO accounts (id, login, email, password) VALUES (%u, '%s', '%s', PASSWORD('%s'));";
    if (Sql_Query(SqlHandle, query, accId, accountName.c_str(), "test@test.com", "password") == SQL_ERROR)
    {
        std::cerr << "Unable to create new account" << std::endl;
        return nullptr;
    }

    query = "SELECT max(charid) FROM chars;";
    if (Sql_Query(SqlHandle, query) == SQL_ERROR || Sql_NumRows(SqlHandle) == 0 || Sql_NextRow(SqlHandle) != SQL_SUCCESS)
    {
        std::cerr << "Unable to get max character ID" << std::endl;
        return nullptr;
    }
    auto charId = std::max(MIN_TEST_CHAR_ID, (uint32)Sql_GetUIntData(SqlHandle, 0) + 1);

    auto testChar       = std::make_unique<TestChar>();
    testChar->accountId = accId;
    testChar->charId    = charId;

    // Create necessary rows in tables
    auto charName = "T" + std::to_string(charId);

    const char* Query = "INSERT INTO chars(charid,accid,charname,pos_zone,nation,playtime) VALUES(%u,%u,'%s',%u,%u,%u);";
    if (Sql_Query(SqlHandle, Query, charId, accId, charName.c_str(), zoneId, 0, 4000000) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_look(charid,face,race,size) VALUES(%u,%u,%u,%u);";

    if (Sql_Query(SqlHandle, Query, charId, 1, 1, 1) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char look" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_stats(charid,mjob) VALUES(%u,%u);";

    if (Sql_Query(SqlHandle, Query, charId, 1) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char stats" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_equip(charid, jobid) VALUES(%u, %u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId, 0) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char equip" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_exp(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char exp" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_jobs(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char jobs" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_pet(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char pet" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_points(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char points" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_unlocks(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char unlocks" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_profile(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char profile" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_storage(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char storage" << std::endl;
        return nullptr;
    }

    Query = "DELETE FROM char_inventory WHERE charid = %u";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to delete from char inventory" << std::endl;
        return nullptr;
    }

    Query = "INSERT INTO char_inventory(charid) VALUES(%u) \
            ON DUPLICATE KEY UPDATE charid = charid;";
    if (Sql_Query(SqlHandle, Query, charId) == SQL_ERROR)
    {
        std::cerr << "Unable to create new char inventory" << std::endl;
        return nullptr;
    }

    return testChar;
}

static std::vector<std::string> charIdTables = {
    "chars",
    "char_effects",
    "char_equip",
    "char_exp",
    "char_fellow",
    "char_gmmessage",
    "char_inventory",
    "char_jobs",
    "char_keyitems",
    "char_linkshells",
    "char_look",
    "char_merit",
    "char_missions",
    "char_pet",
    "char_points",
    "char_profile",
    "char_quests",
    "char_recast",
    "char_skills",
    "char_spells",
    "char_stats",
    "char_storage",
    "char_style",
    "char_unlocks",
    "char_vars",

    "accounts_parties",
    "accounts_sessions",
    "conflict_entries",
    "audit_custom",
};

void TestChar::cleanAll()
{
    for (auto& tableName : charIdTables)
    {
        auto query = "DELETE FROM %s WHERE charid >= %u";
        Sql_Query(SqlHandle, query, tableName.c_str(), MIN_TEST_CHAR_ID);
    }

    auto query = "DELETE FROM accounts WHERE id >= %u";
    Sql_Query(SqlHandle, query, MIN_TEST_ACC_ID);

    query = "DELETE FROM server_auctionhouse WHERE seller >= %u";
    Sql_Query(SqlHandle, query, MIN_TEST_CHAR_ID);

    query = "DELETE FROM server_deliverybox WHERE charid >= %u OR senderid >= %u";
    Sql_Query(SqlHandle, query, MIN_TEST_CHAR_ID, MIN_TEST_CHAR_ID);

    query = "DELETE FROM audit_exchange WHERE source >= %u OR target >= %u";
    Sql_Query(SqlHandle, query, MIN_TEST_CHAR_ID, MIN_TEST_CHAR_ID);
}

TestChar::~TestChar()
{
    for (auto& tableName : charIdTables)
    {
        auto query = "DELETE FROM %s WHERE charid = %u";
        Sql_Query(SqlHandle, query, tableName.c_str(), this->charId);
    }

    auto query = "DELETE FROM accounts WHERE id = %u";
    Sql_Query(SqlHandle, query, this->accountId);

    query = "DELETE FROM server_auctionhouse WHERE seller = %u";
    Sql_Query(SqlHandle, query, this->charId);

    query = "DELETE FROM server_deliverybox WHERE charid = %u OR senderid = %u";
    Sql_Query(SqlHandle, query, this->charId, this->charId);

    query = "DELETE FROM audit_exchange WHERE source = %u OR target = %u";
    Sql_Query(SqlHandle, query, this->charId, this->charId);
}