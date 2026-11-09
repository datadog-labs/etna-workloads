Language-service "Move to file" refactor on `/a.ts`, targeting `/other.ts`, which exists on the host (`fileExists` is true) but isn't in the program's root files.
Clean: the refactor returns no edits (`[]`) because the guard rejects a target file that is not in the program.
Injected: the guard is missing, so the refactor throws "Debug Failure." instead.
