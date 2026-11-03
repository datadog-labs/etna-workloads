repro.go: two functions each define a local generic type `T[_ any]`, and the program prints the reflect type names of their instances.
Clean: both print `main.T[int]`. Buggy: the "·N" scope suffix stays inside the name (e.g. `main.T·1[int]`) because mangling puts it before the type arguments.
