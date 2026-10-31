Compiles a synthetic AST (all locations removed) of an if/else containing try/except followed by `~name_5`.
With the bug, convert_pseudo_ops leaves a redundant jump and a debug assert fails in the buggy build; the clean build compiles fine.
