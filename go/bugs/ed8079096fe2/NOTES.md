repro.go is test/reflectmethod7.go (issue 44207) minus the `// run` header. It calls a method of S through
reflect on *S (found with MethodByName on reflect.PointerTo(S)) via Func.Call.
Clean: exits 0 silently. Buggy: the program crashes (fatal runtime error, exit status 2 from go run)
because the method is missing or wrong in the *S method table.
