# Rationale

## Lib/multiprocessing/forkserver.py — `set_forkserver_preload`
Reverses the single implementation hunk of the fix: the type check iterates
`self._preload_modules` (the previously stored list) instead of the
`modules_names` argument. In v3.15.2 the function gained `on_error`, but the
check line is otherwise identical to the pre-fix code, so the change is a
one-token revert. The argument is therefore never validated.

## Oracle
`TestStartMethod.test_context_check_module_types` fails:
`ctx.set_forkserver_preload([1, 2, 3])` no longer raises
`TypeError('module_names must be a list of strings')`.
