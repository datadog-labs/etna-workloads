# Rationale

Fix gh-81441 / bpo-37260 made `shutil.rmtree` ignore `FileNotFoundError` for entries that vanish mid-walk. On Linux v3.15.2 uses `_rmtree_safe_fd` / `_rmtree_safe_fd_step`, so the bug is re-introduced there (Lib/shutil.py only).

Hunks reversed:
- Fix hunks adding `except FileNotFoundError: continue` around `entry.is_dir()` and `os.unlink(entry.name, dir_fd=topfd)` in `_rmtree_safe_fd`: removed the same handlers in `_rmtree_safe_fd_step`. A file deleted after scandir now reaches `onexc(os.unlink, ...)`.
- Fix hunks ignoring `FileNotFoundError` on `os.rmdir(entry.name, dir_fd=topfd)` and `os.open`: in today's code these are covered by the final `except FileNotFoundError` clause of `_rmtree_safe_fd_step` (`if orig_entry is None or func is os.close`). Removed it, so all errors go to the generic `except OSError`. A subdirectory that vanished now reports to `onexc`.

Not reverted: `_rmtree_unsafe` (os.walk based now; not used on Linux).

Oracle failing: `TestRmTree.test_rmtree_deleted_race_condition` (AssertionError in `_onexc`, which gets a FileNotFoundError for an unlink/lstat/rmdir of an already-removed entry).
