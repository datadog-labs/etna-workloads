# Rationale

## Lib/asyncio/__main__.py
The fix changed the PYTHONSTARTUP guard to `not sys.flags.isolated and (...)`. In v3.15.2 the
guard is `not sys.flags.ignore_environment and (...)`, which is a later variant of the same
check. I reverted it to the pre-fix unconditional `if startup_path := os.getenv("PYTHONSTARTUP"):`,
so the asyncio REPL runs PYTHONSTARTUP even under `-I`.

## Oracle
`test_asyncio_repl_respects_isolated_mode` fails: "should not print" from the startup script
appears in the REPL output under `-I`.
