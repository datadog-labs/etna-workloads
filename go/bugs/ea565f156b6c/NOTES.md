repro.go is the upstream test for issue 61778 (switch "" with case string(append(s,'a'))) plus a main.
The len(string([]byte)) optimization drops the conversion's init nodes in the buggy compiler;
compare output of go run -trimpath repro.go between toolchains (clean: runs fine; buggy: compiler failure).
