Creates an expression index on coalesce(x,pi()) and then uses json_quote() on the same
expression. The expression walker exprNodeCanReturnSubtype() sees pi() with a NULL arg list.
The buggy shell hits the incorrect ALWAYS() on that NULL list (assertion failure); the clean shell prints 3.1415926535897931.
