repro.py defines empty ctypes Structures (Structure, LittleEndianStructure, BigEndianStructure) with `_align_ = 0` and prints their alignment.
Clean: prints alignment 1 for each. Buggy: `align == 1` (a no-op comparison) leaves align at 0, so class creation fails with `AssertionError: assert multiple > 0` in `ctypes/_layout.py` `round_up`.
