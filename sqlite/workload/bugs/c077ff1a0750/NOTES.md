Reproducer: `repro.sql` runs json_each() on a corrupt JSONB object whose last member has a label but no value (from json101-26.1).

Clean shell: prints `eee` (jsonSkipLabel returns the label index when the value would fall outside the blob).
Buggy shell: `Error near line 1: malformed JSON`, exit status 1.
