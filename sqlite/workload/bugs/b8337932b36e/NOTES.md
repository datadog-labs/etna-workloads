Evaluates `->` and `->>` with a numeric-looking *string* RHS (e.g. `'2'`).
Clean: treated as an object key (so `{"2":"two"}` gives `two`) and as a non-index on arrays (NULL).
Buggy: the string is treated as an array index / numeric, so object lookups return NULL and array lookups return the element.
