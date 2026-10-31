Reproducer: evaluates f-strings with debug expressions (`f'{r"\xff"=}'`, `f'{r"\n"=}'`, `f"{'\''=}"`, `f'{'\xc5'=}'`) and prints the reprs.
Clean: the expression text is kept raw, e.g. `r"\xff"=...`.
Buggy: the text is escape-decoded, giving `r"ÿ"=...`, a real newline in `r"\n"`, and `'Å'=` for `'\xc5'`.
