# Rationale

Fix 36f729e2bc35 made createdb() inherit the template's ICU locale only when the
(resolved) locale provider is ICU, and only after the provider is resolved.
Without that, creating a libc database from an ICU template carries a non-NULL
locale into a libc database and trips the assertion on dblocale / dblocprovider
before the pg_database insert.

## Changed hunks (src/backend/commands/dbcommands.c, createdb())

1. Defaulting block (traces to the single fix.patch hunk). The fix moved the
   `dbiculocale = src_iculocale` default below the provider default and gated it
   on ICU. In today's code the field is `dblocale`/`src_locale`, and the gate is
   `dblocprovider == src_locprovider`. Reversed: `dblocale = src_locale` is now
   done unconditionally and before `dblocprovider` is defaulted.
2. Removed `if (dblocprovider == COLLPROVIDER_LIBC) dblocale = NULL;`.
   Later code added this line, which clears the locale for libc and masks the
   bug. Removing it is needed so the unconditional inheritance in hunk 1 shows
   up again. It is not a separate fix.patch hunk and is the one adaptation
   beyond a direct reversal.

Result: creating a libc database from an ICU template leaves dblocale set, so
`Assert((dblocprovider != COLLPROVIDER_LIBC && dblocale) || (dblocprovider ==
COLLPROVIDER_LIBC && !dblocale))` fails and the server crashes.

## Failing oracle cases
38 of 60 fail, all in src/bin/scripts|t/020_createdb.pl. The first failure is
"create database with libc provider from template database with icu provider".
Later cases fail as "missing" because the test run aborts. Examples:
- fails for encoding not supported by ICU: matches
- shared dependencies copied over to target database
- createdb with incorrect --lc-ctype (status/stderr/stdout)
- createdb with incorrect --strategy (status/stderr/stdout)

The full list is in logs/o.txt.
