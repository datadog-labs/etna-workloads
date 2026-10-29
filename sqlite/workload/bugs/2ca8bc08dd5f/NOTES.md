repro.sh builds a 2-page db with two 60-byte text rows, then shrinks the first row's
serial type (0x8103 -> 0x8101, at offset 1923) so the header ends exactly but the data
is 2 bytes short of the record size. Then it runs `SELECT substr(x,1,8) FROM t1`.

Clean shell: "database disk image is malformed" (the fix checks for unused record bytes).
Buggy shell: the check is removed, so the query succeeds and returns rows without an error.
