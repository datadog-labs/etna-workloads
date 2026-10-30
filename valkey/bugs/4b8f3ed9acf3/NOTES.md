Reproducer: writes an AOF containing an unknown command (`bla foo hello`), starts the server with
`--hide-user-data-from-log no`, and greps the log after the server exits on load failure.
Clean build logs "Error reading the append only file ..., error: unknown command 'bla' ..."; the buggy build
logs the old "Unknown command 'bla' reading the append only file". The script prints which message appeared.
(`--hide-user-data-from-log no` is needed because the clean build otherwise redacts the error.)
