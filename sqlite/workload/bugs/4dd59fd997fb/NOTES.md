json_tree()/json_each() `value` column for arrays/objects must carry the JSON subtype.
repro.sql inserts it via json_insert(); clean gives {"a":[1,2,3]}, buggy gives {"a":"[1,2,3]"} (string, quoted).
