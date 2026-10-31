Reproducer: a `@dataclass(slots=True)` class contains a function whose `__class__` cell is empty (gh-148947).
Clean: decoration succeeds and calling `meth()` raises NameError.
Buggy: `_update_func_cell_for__class__` reads the empty cell, so decoration raises ValueError.
