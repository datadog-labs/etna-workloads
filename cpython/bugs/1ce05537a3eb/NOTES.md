Reproducer sets `func.argtypes` on a CFUNCTYPE function pointer created with paramflags.
Fixed: re-validates paramflags, so assigning `(c_char_p, c_int)` with an out-param raises
TypeError ("must be a pointer type"). Buggy: no validation, assignment silently succeeds.
