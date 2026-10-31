The reproducer simulates the race in bpo-37260. A file is deleted after scandir() lists it and before `shutil.rmtree` unlinks it. It does this by wrapping `os.unlink` so the file is removed first and the real unlink then raises FileNotFoundError.

- Clean interpreter: FileNotFoundError is ignored. `onexc` is never called, so the output is `[] False`.
- Buggy interpreter: `onexc` is called with the FileNotFoundError, so the output is `[('racing_unlink', 'd/f', 'FileNotFoundError')] False`.
