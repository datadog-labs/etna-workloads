`repro.py` calls `linecache.updatecache()` with invalid filenames: one containing a NUL byte and one containing surrogate code points.

- Clean: both calls return `[]`, because `ValueError` from `os.stat()` is caught.
- Buggy: the injection stops `updatecache` from catching `ValueError`. The NUL name raises `ValueError` (embedded null byte), so the output is `ValueError` and then `[]`.

The surrogate name returns `[]` on both interpreters. Only the NUL name shows the difference.
