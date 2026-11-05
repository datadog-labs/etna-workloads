# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d3406d80360776bbcafa05d8b966806012f9594e ("Fix handling of default option values in createuser"), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/bin/scripts/createuser.c

Failing oracle cases:
- `src/bin/scripts|t/040_createuser.pl|--member-of: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|--role: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|--with-admin: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|--with-member: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|SQL CREATE USER run: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|add a role as a member of the newly created role: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|add a role as a member with admin option of the newly created role: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a BYPASSRLS role: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a CREATEROLE user: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a non-login role: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a role with a password expiration date: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a role without BYPASSRLS: SQL found in server log`
- `src/bin/scripts|t/040_createuser.pl|create a superuser: SQL found in server log`
