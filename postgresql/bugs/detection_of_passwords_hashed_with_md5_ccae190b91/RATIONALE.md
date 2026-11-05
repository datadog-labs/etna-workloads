# Rationale

src/backend/libpq/crypt.c, get_password_type(): reverts the crypt.c hunk of fix_impl.patch.
The MD5 check no longer verifies that the 32 characters after "md5" are hex digits (the MD5_PASSWD_CHARSET strspn check is removed).
The SCRAM check no longer calls parse_scram_secret() (today's name for parse_scram_verifier). It only checks the "SCRAM-SHA-256$" prefix.
Malformed strings are therefore classified as MD5 or SCRAM and not as plaintext.
The unused local variables were removed along with the checks.
I left the other hunks alone (the header declaration, the md5.h define, and the exported parse function). Reverting them isn't needed to bring the bug back.

Failing oracle case: src/test/regress||password
