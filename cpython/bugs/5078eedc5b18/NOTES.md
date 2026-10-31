repro.py evals 200 nested f-strings. Clean: SyntaxError 'too many nested f-strings or t-strings'. Buggy (nesting limit check removed): MemoryError 'Parser stack overflowed'.
