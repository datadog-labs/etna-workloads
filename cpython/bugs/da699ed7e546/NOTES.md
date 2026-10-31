Reproducer builds a symtable for a lambda and a genexpr and prints the child table names. Clean: ['<lambda>', '<genexpr>']; buggy: ['lambda', 'genexpr'] (names can collide with user-defined names).
