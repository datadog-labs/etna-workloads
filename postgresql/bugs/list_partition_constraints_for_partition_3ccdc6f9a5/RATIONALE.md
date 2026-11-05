# Rationale

Hunk: src/backend/partitioning/partbounds.c, make_partition_op_expr() (list strategy).
Traces to fix.patch hunk in make_partition_op_expr (catalog/partition.c then), which added
`!type_is_array(key->parttypid[keynum])` to the condition for building an ArrayExpr + ScalarArrayOpExpr.
Removing that check means array-typed partition keys again get an ArrayExpr with
array_typeid = get_array_type(array type) (invalid), producing a broken list partition constraint.

Failing oracle cases: src/test/regress||create_table (foreign_data and partition_prune still pass).
