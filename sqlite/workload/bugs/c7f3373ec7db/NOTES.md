`repro.sh` sets `.limit length 10000` and runs `CREATE TABLE <10000-char name> (x PRIMARY KEY)`. The autoindex name `sqlite_autoindex_<name>_1` is then too long to build.

- clean: `string or blob too big (18)`.
- buggy: assertion failure in `sqlite3EndTable` (`TF_HasPrimaryKey ... sqlite3PrimaryKeyIndex(p)!=0`) and abort, exit 134.

The other listed failures (18.x, 19.x) appear to be follow-on failures after 17.1 aborts the test run.
