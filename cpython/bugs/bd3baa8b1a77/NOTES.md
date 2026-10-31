repro.py calls SourceLoader.path_mtime and reads machinery.DEBUG_BYTECODE_SUFFIXES / OPTIMIZED_BYTECODE_SUFFIXES, recording warnings.
Clean: each emits a DeprecationWarning. Buggy: no warnings are emitted (empty lists).
