get_type_hints() on a function whose `__wrapped__` points to itself.
Clean: raises ValueError("wrapper loop when unwrapping ..."), which the script prints.
Buggy: the unwrap loop has no cycle check, so it hangs forever.
