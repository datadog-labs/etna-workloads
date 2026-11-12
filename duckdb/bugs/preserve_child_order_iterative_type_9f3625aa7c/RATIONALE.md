# Rationale
File: src/include/duckdb/common/type_visitor.hpp

1. `TypeVisitor::RebuildType` (STRUCT/TUPLE/UNION): restored the forward loop `for (auto &child : children) child.second = PopType(result_stack);`. Fix hunk replaced it with a reverse-order loop. Result stack pops give children in reverse, so fields get assigned in wrong order (heterogeneous children swap types).
2. `TypeVisitor::Contains`: removed the `std::reverse` of the pushed children, so the worklist (a stack) visits children in reverse declaration order. Traces to the fix's second hunk.

Expected oracle failures: test_type_visitor.cpp (all three cases, order/visit assertions) and replace_type.test. See etna-check output (pending at time of writing).

## etna-check result (3 of 4 oracle units fail)
FAIL test_type_visitor.cpp::TypeVisitor preserves child order ... (line 27: result_children[i].second mismatch)
FAIL test_type_visitor.cpp::TypeVisitor Contains visits children in order and short circuits (line 43: visited order wrong)
PASS test_type_visitor.cpp::TypeVisitor handles deep types without recursion (still passes; not order-dependent)
FAIL test/sql/function/generic/replace_type.test: `{'a': true, 'b': duck, 'c': 1} <> {'a': 42, 'b': duck, 'c': true}`
