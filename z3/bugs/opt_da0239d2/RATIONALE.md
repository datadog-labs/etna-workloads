Changes (src/src/opt/opt_context.{h,cpp}), all tracing to FIX.diff hunks in the same files:
- opt_context.h / ctor / fix_model / reset hunks: m_model_fixed goes back from a per-model set (sref_vector<model>) to a single bool, so "fixed" is a global flag, not tied to a specific model.
- execute_box (x2), post-box m_model = m_box_models[0], and publish_pareto_result: re-added `m_model_fixed = false` that the fix removed.
- set_model on_model hunk: dropped the contains/pop_back bookkeeping that only makes sense for the vector (adaptation of the type change).
Effect: the flag set while fixing a copy for the on-model callback leaks onto the real model, so the model is never converted (m = #x00, "invalid model" under model_validate) -- same bug as #1655.

check.sh: BUILD OK; FAIL z3test:smt2/issue-1655.smt2 (rc=1) (expected output mismatch: invalid model generated, m #x00 vs #xff)
