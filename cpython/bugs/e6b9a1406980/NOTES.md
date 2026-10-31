Reproducer for gh-144984 (ExternalEntityParserCreate error paths).

repro.py makes allocation fail inside `parser.ExternalEntityParserCreate(None)`
using `_testcapi.set_nomemory(1, 10)`, then prints whether MemoryError was
raised and the change in the parent's refcount.

Clean: prints `True` / `0`, exit 0.
Buggy: segfaults (exit -11). The partially built subparser is deallocated with
NULL `handlers`, and clear_handlers no longer guards against that.
