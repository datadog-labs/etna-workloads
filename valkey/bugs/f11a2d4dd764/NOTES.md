repro.sh starts a server and runs `COMMAND GETKEYS EVAL "return 1" 0`.
Clean: returns an empty array (EVAL has no-mandatory-keys). Buggy: "ERR Invalid arguments specified for command".
A control call with 1 key returns `key` on both builds.
