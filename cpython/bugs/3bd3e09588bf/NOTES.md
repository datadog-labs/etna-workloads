Compiles `from __future__ import barry_as_FLUFL;2 <> 3` (and `!=`) with no compiler flags.
Clean: `<>` compiles, `!=` raises SyntaxError "with Barry as BDFL, use '<>' instead of '!='".
Buggy: the parser doesn't enable the future flag mid-line, so `<>` is a SyntaxError and `!=` compiles.
