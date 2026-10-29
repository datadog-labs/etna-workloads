Reproducer: `repro.sql` runs json_insert() with a text value containing embedded U+0000 characters (CAST(x'0000' AS text)).

Clean shell: `{"a":1,"b":"\u0000\u0000"}`. Buggy shell: `{"a":1,"b":""}`, because the injected change uses strlen() and truncates the string at the first NUL.
