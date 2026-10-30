Runs an EVAL that SETs a key to the numeric string "12039611435714932082" and GETs it back.
Clean returns the string unchanged; buggy uses lua_isnumber (true for numeric strings), converting
the string to a double and losing precision (returns 12039611435714930000 style value).
