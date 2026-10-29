Creates an FTS3 table and issues the command 'maxpendinAB64', which is not a valid
option (it only matches "maxpending=" if the prefix compare is truncated to 9 chars).
Clean shell: "SQL logic error", exit 1. Buggy shell: the command is accepted silently, exit 0.
