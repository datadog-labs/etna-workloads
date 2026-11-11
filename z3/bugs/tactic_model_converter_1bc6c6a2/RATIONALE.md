Changed hunk: src/src/model/model.cpp, model::copy_func_interps: `register_decl(kv.m_key, kv.m_value->copy())` -> `register_decl(kv.m_key, kv.m_value)`.

Traces to FIX.diff hunk in tactic/model_converter.cpp (model2mc::operator() registered `m_model->get_func_interp(f)` without `->copy()`).
In today's code that loop is replaced by model::copy_func_interps (used by model2mc), so the missing copy is re-expressed there:
the func_interp is shared between the converter's model and the produced model (both own it), giving double ownership/free (#3221).

check.sh: BUILD OK; FAIL z3test:smt2/3221.smt2 (rc=139, segfault).
