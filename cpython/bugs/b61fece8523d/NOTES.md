Reproducer for GH-125868 (STORE_ATTR_WITH_HINT). `f` is specialized to store to dict slot 1 of an
object with a non-inline dict; it is then run on an object whose dict has slot 1 = 'b' with a NULL value
(slot 0 holds 'b' = "value"). The fixed interpreter deopts on the NULL value and prints `value` then `0`;
the buggy one writes into the dead slot, so the second `test_obj.b` still gives `value`
(or an assertion failure).
