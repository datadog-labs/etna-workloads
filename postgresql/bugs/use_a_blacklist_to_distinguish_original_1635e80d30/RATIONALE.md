# Rationale

Hunk: src/backend/utils/adt/enum.c, `check_safe_enum_use()`.
Traces to the fix.patch hunk in enum.c that added the "is the value blacklisted? if not, it's safe" early return (today spelled `EnumUncommitted(en->oid)`, since the blacklist was later renamed to uncommitted tables).
I removed that check. Every uncommitted, visible pg_enum row is now treated as unsafe, including values made by CREATE TYPE AS ENUM in the same transaction. Before the fix, the heuristic likewise rejected such original values. This breaks single-transaction restores (bug #14825).

Failing oracle case: src/test/regress||enum
