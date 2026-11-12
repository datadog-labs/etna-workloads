# Rationale

The fix changed the grammar from `OtherOperatorExpression BetweenInLikeOp?` to `OtherOperatorExpression InPredicate* BetweenLikeOp?`. That change allowed chained IN predicates. It also changed EscapeClause's operand and regenerated the inlined grammar.

Regenerating the inlined grammar and the generated trampoline would be a large change, so I re-created the old behaviour in the transformer instead.

## Hunk
`src/parser/peg/transformer/transform_expression.cpp`, `PEGTransformerFactory::TransformBetweenInLikeExpression`. This traces to the grammar hunk `InPredicate*` / `BetweenLikeOp?`. It now throws `ParserException("syntax error at or near \"IN\"")` when there is more than one IN predicate, or when an IN predicate is followed by BETWEEN or LIKE. The pre-fix grammar allowed only a single optional BETWEEN/IN/LIKE operator, so chained forms were rejected as parse errors.

I did not restore the EscapeClause operand (`ComparisonExpression` instead of `OtherOperatorExpression`), so only the chaining behaviour is back.

## Oracle result
Only `new_parser_failure_0076.test` is an oracle unit, and it fails:
```
FAIL     test/sql/peg_parser/fuzzer/new_parser_failure_0076.test
         Query unexpectedly failed (test/sql/peg_parser/fuzzer/new_parser_failure_0076.test:5)
         SELECT 1 IN (1, 2) IN (TRUE, FALSE);
         Parser Error: syntax error at or near "IN"
1 of 1 oracle units fail
```
