repro.go is the upstream issue64565 test. It computes max(string(c), m) in a loop.
Escape analysis in the buggy compiler discards min/max arguments, so the temporary string(c) is stack-allocated and overwritten each iteration.
Clean prints 3,3,3; buggy prints 3,2,1.
