repro.go is the issue45323 test body made runnable (g defined, main prints f(2), f(0)).
Clean toolchain compiles and runs it. The buggy toolchain hits an internal compiler error
("panic during phiopt ... index out of range [-1]") because phiopt passes ei-1 instead of 1-ei to convertPhi.
