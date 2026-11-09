Input returns a parenthesized `as` assertion expression preceded by a block comment, at target esnext.
Clean emit keeps `return (` + comment + `.getThing());`; injected drops the paren, emitting `return` followed by a newline and the comment (ASI hazard, changes semantics).
