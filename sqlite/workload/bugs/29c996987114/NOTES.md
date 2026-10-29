repro.sql calls json_patch() on an empty target with a patch containing a nested null.

Clean returns {"a":{"bb":{}}}. Buggy returns {"a":{"bb":{"ccc":null}}}, because nested objects are not scanned for nulls to remove.
