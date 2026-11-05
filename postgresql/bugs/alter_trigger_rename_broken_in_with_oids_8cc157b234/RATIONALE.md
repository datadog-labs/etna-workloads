# Rationale

File: src/backend/commands/trigger.c, function renametrig_internal() (the current home of the code in the fix's renametrig hunk).

Traces to the fix.patch hunk that moved `trigform = GETSTRUCT(tuple)` to after `heap_copytuple()`. I removed the re-fetch of `tgform` from the copied tuple. `tgform` now still points into the original (shared buffer) tuple. `namestrcpy()` therefore modifies the original tuple, and `CatalogTupleUpdate()` writes the unmodified copy, so the rename has no effect.

Failing oracle case: src/test/regress||triggers
