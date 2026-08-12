xi = xi or {}
xi.settings = xi.settings or {}

xi.settings.cexi =
{
    ADMIN_FRONT     = "tcp://127.0.0.1:54555",   -- world <-> tools
    ADMIN_BACK      = "tcp://127.0.0.1:54560",   -- world binds here
    ADMIN_CONN      = "tcp://127.0.0.1:54560",   -- maps connect here
    ADMIN_PUB       = "tcp://127.0.0.1:54562",   -- world pub -> bots
    ZMQ_TOKEN       = "topazisawesome",

    -- Test-server command elevation. When true, CCommandHandler::call gates on
    -- max(m_GMlevel, TEST_SERVER_GM_LEVEL) instead of m_GMlevel, so every
    -- character can run commands up to that permission. m_GMlevel itself is NOT
    -- modified: `#` GM broadcast, player:getGMLevel() and the other GM checks
    -- are unaffected. Use is still written to audit_gm.
    --
    -- Left false here; the test server's deploy workflow writes settings/cexi.lua
    -- (gitignored, survives `reset --hard` + `clean -df`) to turn it on for that
    -- box only. Never enable this on a live server.
    TEST_SERVER          = false,
    TEST_SERVER_GM_LEVEL = 4,
}
