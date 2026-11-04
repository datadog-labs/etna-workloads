repro.sql runs the two mixed scalar/array map() queries from the fix's slt test
(literal keys with column values, and column keys with literal values).
Clean build returns the maps ({a: 1, b: 10}, ...), exit 0. The buggy build panics
("list array" in arrow cast.rs, exit 101) on the first query, because the scalar argument is not expanded to batch size.
