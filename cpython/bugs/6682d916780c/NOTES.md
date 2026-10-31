repro.py builds the symtable for `(x for x in a)` and prints the genexpr child's name.
Clean: `'<genexpr>'`; buggy: `'genexpr'` (the injected symtable_visit_genexp uses the wrong name).
