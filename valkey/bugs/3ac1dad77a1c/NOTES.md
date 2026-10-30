repro.sh starts a server, runs a Lua script that SETs the string "12039611435714932082" and GETs it back.
Clean: returns 12039611435714932082. Buggy: the arg check uses lua_isnumber (true for numeric strings), so the string is converted via a double and returns 12039611435714933000.
