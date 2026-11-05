# Rationale

Changed: `src/common/compression.c`, `validate_compress_specification()`.

Traces to the fix.patch hunk in the same function that added
`&& spec->level != default_level` to the range check, so that each algorithm's
default level is accepted (gzip's Z_DEFAULT_COMPRESSION = -1). The fix stopped
tracking "level specified" in an options flag and instead assigns defaults.
I removed the default-level exemption. The default level that
`parse_compress_specification()` now always assigns (gzip -1) fails the 1..9
range check, so a plain `gzip` spec without a level is rejected.

Failing oracle cases: 143 of 200, all in
src/bin/pg_basebackup t/010_pg_basebackup.pl. They include the gzip, compress=NUM
and tar-format backup cases, e.g. "two files created with --gzip",
"tar format" and "server failure on worker count for gzip: matches".
