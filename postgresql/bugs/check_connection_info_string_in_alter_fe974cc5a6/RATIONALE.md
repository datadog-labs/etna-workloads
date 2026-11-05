# Rationale

- File/function: src/backend/commands/subscriptioncmds.c, AlterSubscription(), case ALTER_SUBSCRIPTION_CONNECTION.
- Traces to the single fix_impl.patch hunk, which added load_file("libpqwalreceiver") and walrcv_check_conninfo(stmt->conninfo) there. I removed both calls (today's code also passes a password-required argument to the check).
- Effect: ALTER SUBSCRIPTION ... CONNECTION no longer validates the conninfo string, so invalid strings are accepted.

Failing oracle case: src/test/regress||subscription
