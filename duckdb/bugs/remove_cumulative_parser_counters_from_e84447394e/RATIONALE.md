# Rationale

File: src/src/parser/peg/transformer/transform_common.cpp

1. `PEGTransformerFactory::TransformMapType` – reverses the first hunk of the fix: re-added the cumulative
   `transformer.stack_depth += 1` plus the `>= max_expression_depth` check at function entry. The counter is never
   decremented, so every MAP type in a statement permanently consumes depth.
2. `PEGTransformerFactory::TransformColIdType` – reverses the second hunk: same cumulative increment/check, so
   every STRUCT field accumulates depth.

Wide STRUCT (1500 fields) / many MAPs (1100) therefore exceed max_expression_depth (1000) and throw
"Max expression depth limit ... exceeded", failing test/sql/parser/wide_type_definitions.test.

Oracle result: see below.

```
build ok; running oracle tests ...
FAIL     test/sql/parser/wide_type_definitions.test
         test/sql/parser/wide_type_definitions.test:11 :: Query unexpectedly failed
         Parser Error: Max expression depth limit of 1000 exceeded. ...
1 of 1 oracle units fail
```
