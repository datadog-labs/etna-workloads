# Rationale

## Hunk: src/optimizer/rule/move_constants.cpp, MoveConstantsRule::Apply, `*` branch
Traces to the fix's `*` hunk ("result is out of range - bail"). Re-introduced the old behaviour: when
the divided constant does not fit the type, the rule folds the comparison to `ConstantOrNull(child, false)`
for every comparison operator, instead of bailing (`return nullptr`) for all but the equality cases.
So `x * -1 <> INT_MIN` becomes constant false (wrong; should be true).

The +, -, and unary-minus hunks were left alone (only the `*` hunk was reverted).

## Oracle result
```
FAIL     test/sql/optimizer/expression/test_move_constants_overflow.test
         ...test_move_constants_overflow.test:7
         SELECT x * -1 <> CAST(-2147483648 AS INTEGER) FROM (VALUES (CAST(0 AS INTEGER))) t(x);
         Expected result: true   Actual result: 0
1 of 1 oracle units fail
```
