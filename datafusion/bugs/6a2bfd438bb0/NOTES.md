Reproducer: LIKE / ILIKE between a list (REGEXP_MATCH result) and `[]`.
Clean build: planning error "There isn't a common type to coerce List(Utf8View) and List(Null) in LIKE/ILIKE expression".
Buggy build: like_coercion accepts list types, so planning succeeds and execution hits an internal assertion error ("invalid operator or data type mismatch for nested data, op ~~ ...").
