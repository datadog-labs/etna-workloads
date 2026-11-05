# Rationale

## Change: src/backend/commands/dbcommands.c, createdb()

fix.patch hunks (both in createdb):
1. Removed the early check "ICU locale cannot be specified unless locale provider is ICU". It ran right after option parsing, before the provider was resolved from the template.
2. Added the check later, once the provider is final.

The current code names the options `iculocaleEl` and `dblocprovider`, and already has the later check inside "validate provider-specific parameters". To reverse the fix:
- I re-added the early check after the locale provider option is parsed: `if (iculocaleEl && dblocprovider != COLLPROVIDER_ICU) ereport(ERROR, ...)`.
- I removed the later `if (iculocaleEl)` check in the `dblocprovider != COLLPROVIDER_ICU` block.

Bug restored: when no PROVIDER is given, `dblocprovider` is still '\0' at the early check. `CREATE DATABASE ... ICU_LOCALE=...` therefore fails even when the template database uses the ICU provider, which the provider would have been inherited from.

## Failing oracle case
- src/bin/scripts|t/020_createdb.pl|create database with icu locale from template database with icu provider
