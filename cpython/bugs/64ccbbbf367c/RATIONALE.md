# Rationale

Only `Lib/zipapp.py` (`create_archive`) changed. v3.15.2 had already moved the filter into the up-front `files_to_add` dict, so a plain reversal of the fix hunk no longer applied. I restored the pre-fix code instead:

- Removed the up-front `files_to_add` computation and the `if target in files_to_add: raise ZipAppError(...)` check. These are the lines the fix added.
- Restored the lazy `for child in sorted(source.rglob('*'))` loop inside the open `ZipFile`, with the old condition `filter is None or filter(arcname) and child.resolve() != arcname.resolve()`. This is the code the fix removed.

The target file is now created before the source tree is listed, so a target inside the source directory gets added to itself. It is also never rejected when it is one of the source files.

Oracle cases that fail:
- `test_create_archive_self_insertion`: `namelist()` has 3 entries instead of 2, because `target.pyz` is included.
- `test_target_overwrites_source_file`: `ZipAppError` is not raised.
