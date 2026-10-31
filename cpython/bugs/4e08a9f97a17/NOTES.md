Writes four syntax-error scripts to files and runs each with the current interpreter, printing whether stderr has "Did you mean" and its last line.
Clean: all four suggest the keyword (else, elif, return, if). Buggy: the `returm` and `[x for x\nin range(3)\nof x]` cases print a bare "invalid syntax" with no suggestion (file-based keyword typo detection broken).
