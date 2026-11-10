Assigns an object literal with an extra property `c` (nested) to an intersection of two string index signatures.
Clean: reports TS2353 excess property 'c' (exit 2). Injected: no error (exit 0), since index signatures aren't checked for fresh literals.
