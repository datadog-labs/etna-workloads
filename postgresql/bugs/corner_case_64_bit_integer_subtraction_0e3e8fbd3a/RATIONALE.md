# Rationale

File: src/include/common/int.h, function pg_sub_s64_overflow (fallback branch).

Traces to the single fix_impl.patch hunk:
- Reverted `a >= 0 && b < 0` back to `a > 0 && b < 0`, so 0 - PG_INT64_MIN is no longer detected as overflow, and removed the explanatory comment.
- Because the build uses __builtin_sub_overflow (or int128), the fallback is never compiled in. I changed the two preprocessor conditions to `#if 0` / `#elif 0` for this function only, which simulates a platform without those facilities, so the bug is reachable.

Failing oracle case: src/test/regress||int8
