# Rationale

Both hunks of the fix to `Lib/tarfile.py` still apply in v3.15.2 and were reversed:

1. `TarFile._get_extract_tarinfo`: `except (OSError, UnicodeEncodeError, FilterError)` -> `except (OSError, FilterError)`.
   A UnicodeEncodeError raised by the extraction filter (e.g. `os.path.realpath` on a surrogate name) is no longer routed to `_handle_fatal_error`.
2. `TarFile._extract_one`: `except (OSError, UnicodeEncodeError)` -> `except OSError`.
   A UnicodeEncodeError from `_extract_member` is no longer handled like an OSError.

Failing oracle case: `test.test_tarfile.TestExtractionFilters.test_extract_unencodable`.
With `errorlevel=1` the error should be raised via `_handle_fatal_error` (it still raises, but not through that path), and with `errorlevel=0` it should be swallowed and logged as `tarfile: UnicodeEncodeError ...`. Instead the raw UnicodeEncodeError escapes `extractall()`.
