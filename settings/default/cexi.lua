xi = xi or {}
xi.settings = xi.settings or {}

xi.settings.cexi =
{
    ADMIN_FRONT     = "tcp://127.0.0.1:54555",   -- world <-> tools
    ADMIN_BACK      = "tcp://127.0.0.1:54560",   -- world binds here
    ADMIN_CONN      = "tcp://127.0.0.1:54560",   -- maps connect here
    ADMIN_PUB       = "tcp://127.0.0.1:54562",   -- world pub -> bots
    ZMQ_TOKEN       = "topazisawesome",
}
