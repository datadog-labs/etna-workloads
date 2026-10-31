# Rationale

Fix hunk reversed: the `if self.namer is None:` branch of `TimedRotatingFileHandler.getFilesToDelete` (Lib/logging/handlers.py).
In v3.15.2 this branch uses `prefix = baseName + '.'` and `extMatch.fullmatch(suffix)`. I restored the pre-fix logic there:
the prefix is computed from `os.path.splitext(baseName)[0] + '.'` (dropping the extension), files only need to start with `baseName`,
and the suffix is split on '.' with any part matching `extMatch` accepted. The namer branch is unchanged.

Effect: a handler for `a.log` also picks up `a.log.b.<timestamp>` files belonging to a handler for `a.log.b`, so the wrong files are offered for deletion.

Failing oracle case: `TimedRotatingFileHandlerTest.test_compute_files_to_delete_same_filename_different_extensions`
(candidate count and the suffix regex assertion fail because `a.log.b.*` files are included for the `a.log` handler).
