Compiles a class with three `self.X = ...` assignments in every permutation of a/b/c
and prints `T.__static_attributes__`. Clean: always `('a', 'b', 'c')` (sorted).
Buggy: tuple is in assignment order, so it varies with the permutation.
