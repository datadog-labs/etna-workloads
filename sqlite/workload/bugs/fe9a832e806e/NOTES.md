repro.sql: json_set/json_insert with a quoted new path key ($."d"). Clean gives {"a":1,"d":4}; buggy stores the quoted path text as the key: {"a":1,"\"d\"":4}.
