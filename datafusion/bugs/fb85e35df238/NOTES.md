repro.sql compares integer/float columns against string literals (`i > '100'`, `f = '5'`, `i = 'hello'`).
Clean build coerces the string to numeric: correct numeric results, and a cast error for 'hello'.
Buggy build coerces the number to a string: lexicographic comparisons (`i > '100'` returns 5, 30, 325), `f = '5'` returns nothing, and `i = 'hello'` returns no rows instead of an error.
