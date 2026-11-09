Input: parenthesized `satisfies` expressions with a leading comment, e.g. `(/*comm*/ 10 satisfies number)`, compiled with comments kept.
Clean: the parentheses are removed, emitting `const a = /*comm*/ 10;`.
Injected: the parentheses are kept, emitting `const a = ( /*comm*/10);` (and double parens for `b`).
