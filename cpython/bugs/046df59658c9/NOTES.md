Reproducer: a `Flag` decorated with `enum.global_enum` (which installs `global_str` as `__str__`); `str(NoName(0))` hits the pseudo-member (no name) branch.
Clean prints `'NoName(0)'`; buggy raises `NameError: cls_name` because the injection removed the `cls_name = ...` assignment in `global_str`.
