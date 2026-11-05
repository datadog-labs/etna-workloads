# Rationale

File: src/backend/optimizer/path/equivclass.c, function find_computable_ec_member (plus the restored static helper is_exprlist_member and its prototype).

Traces to the fix_impl.patch hunks: the one that removes the is_exprlist_member prototype and function, and the one that replaces the pre-computed `exprvars` list with a per-Var `is_exprlist_member(var, exprs)` test.
The restored test only accepts an EC member whose Vars appear as whole expressions in "exprs" (by equal()). It does not look at the Vars inside the expressions. Members that are computable from expressions such as Var+2 (appendrel children) are therefore rejected, or the wrong members are picked.

Oracle case expected to fail: src/test/regress||inherit
