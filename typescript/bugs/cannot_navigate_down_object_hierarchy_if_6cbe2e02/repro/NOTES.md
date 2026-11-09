Language service getImplementationAtPosition on interface A, with B extends A, C implements B, D extends C.
Clean: returns implementations B, C, D. Injected: interface B (heritage-clause interface) is missing, so the result is empty/incomplete.
