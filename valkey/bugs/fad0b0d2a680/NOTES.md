repro.sh blocks a client on BLPOP via a raw TCP connection, then runs CLIENT UNBLOCK <id> ERROR from the CLI.
It prints the UNBLOCKED reply, errorstats, the blpop commandstats and total_error_replies.
Clean build: `cmdstat_blpop:calls=1,rejected_calls=1,failed_calls=0`.
Buggy build: `rejected_calls=0`, because unblockClientOnError no longer records ERROR_COMMAND_REJECTED.
