repro.sh starts a server and sends `GET|`, `GET|SET`, `GET|SET|OTHER` and `CONFIG|GET GET_XX` (issue #10070).
Clean build: all four return "unknown command". Buggy build: `CONFIG|GET GET_XX` returns
"unknown subcommand 'GET_XX'. Try CONFIG|GET HELP." instead, because the name is split on `|` when looking for a container command.
The other three inputs behave the same on both builds, and the server did not crash on them here.
