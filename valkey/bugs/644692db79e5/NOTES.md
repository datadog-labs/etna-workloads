repro.sh starts a server, opens a raw socket, runs `script debug sync` + `eval`, then sends `server ping` inside the Lua debugger session.
Clean: the debugger runs the command and replies with PONG. Buggy: `server` is not recognised as a debugger call command, so no PONG is returned.
