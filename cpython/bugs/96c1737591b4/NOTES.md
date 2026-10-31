repro.py builds the "try: pass / except: pass" instruction sequence from test_exception_table
with _testinternalcapi.assemble_code_object and prints its dis output.
Clean: the disassembly ends with an ExceptionTable (L1 to L2 -> L2 [0], L2 to L3 -> L3 [1] lasti).
Buggy: the exception table is missing, because _PyCfg_JumpLabelsToTargets no longer calls
label_exception_targets.
