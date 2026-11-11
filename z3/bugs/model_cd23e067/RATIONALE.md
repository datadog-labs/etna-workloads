Changed hunk: src/src/model/model_evaluator.cpp, expand_as_array. Traces to the single implementation hunk of FIX.diff, which added creation of a default func_interp for an uninterpreted `g` with no interpretation. In today's code the block also had a `!g->is_skolem()` guard; I removed the whole block, so (as-array f) for an unconstrained f is left as as-array under model completion, as before the fix.

check.sh: model_evaluator FAIL (assertion `!au.is_as_array(v)` at test/model_evaluator.cpp:113).
