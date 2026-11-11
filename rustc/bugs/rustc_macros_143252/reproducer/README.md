Prints HIR with -Zunpretty=hir; the injected compiler uses word_space(":") so a line break can follow the colon in attribute fields (e.g. 'reprs:' newline '[ReprC]'), differing from the clean output.
