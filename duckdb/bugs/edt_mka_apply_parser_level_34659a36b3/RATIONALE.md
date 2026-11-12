# Rationale

Hunk: `src/parser/peg/transformer/transform_expression.cpp`, `PEGTransformerFactory::TransformBaseExpression`, method-chain (FUNCTION indirection) branch.

Traces to the fix's hunk that made the method-chain branch call the shared `TransformParserFunctionRewrite()` for every name. Before the fix, only `ifnull` was rewritten on this path. The change restores that. The shared helper is only called with the method-chain form when the name is `ifnull`. `try`, `date`, `construct_array`, `coalesce`, `unpack` and the others fall through to catalog lookup. The helper itself and the plain path are unchanged.

Because those names go to the catalog, they fail with "Catalog Error: Scalar Function with name <x> does not exist!".

## Oracle result
```
FAIL     test/sql/parser/parser_rewrites_method_chain.test
         test/sql/parser/parser_rewrites_method_chain.test:52
         SELECT ('abc'::INTEGER).try();
         Catalog Error: Scalar Function with name try does not exist!
1 of 1 oracle units fail
```
