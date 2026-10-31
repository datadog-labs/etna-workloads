repro.py tries to subclass `ClassVar[int]` and `Final[int]` (special-form generic aliases) and prints the resulting TypeError.

- clean: `TypeError Cannot subclass typing.ClassVar[int]` (and the same for `Final[int]`).
- buggy: `_GenericAlias.__mro_entries__` lacks the `_SpecialForm` check, so the error is the misleading `_SpecialForm.__init__() takes 2 positional arguments but 4 were given`.

I couldn't run `./check.sh` because bwrap failed on a missing `.claude/launch.json`. I ran both interpreters by hand in an empty directory instead.
