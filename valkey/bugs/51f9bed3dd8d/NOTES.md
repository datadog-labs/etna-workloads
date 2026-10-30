`repro.sh` runs `FUNCTION LOAD foo bar <code>` with unknown options, then `FUNCTION LIST`.
Clean: `ERR Unknown option given: foo`, and no library is loaded.
Buggy: the unknown options are silently ignored, so the library loads and shows up in `FUNCTION LIST`.
