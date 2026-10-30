Runs `COMMAND GETKEYS sort_ro abc`. Clean build replies `abc`; the buggy build
doesn't set result->numkeys in sortROGetKeys, so the reply is empty.
