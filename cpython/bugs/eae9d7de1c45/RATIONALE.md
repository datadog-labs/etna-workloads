# Rationale

Hunk reversed: `BlockFinder.tokeneater` in `Lib/inspect.py` (fix hunk 2).
The fix made the first non-INDENT/non-`async` token start the block, with
`singleline = token not in ("def", "class")`, so generator expressions are
scanned to the end of the logical line. I restored the old logic: only
`def`/`class`/`lambda` start a block (`singleline = token == "lambda"`).
The `self.singleline` rename (hunk 1) was already in the tree and is kept.
Other tokens, including a generator expression's first token, only set
`passline`, so the finder never starts at the genexp and runs on into later code.

I kept the tree's existing `COMMENT`/`NL` skip and the `async` skip. Those are
unrelated to this fix.

Failing oracle case: `TestBuggyCases.test_generator_expression`. `getsource` of
`mod2.ge377` returns the following code, including `func383`, instead of
lines 377-380.
