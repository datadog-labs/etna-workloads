repro.go is the issue81165 test as a runnable program. It declares a generic method on a pointer-receiver alias (`type someTypeAlias = *someType`) and calls it.
go-clean builds and runs it, printing "42" twice and exiting 0.
go-buggy fails at link time with "relocation target main.(*someType).FailedLink[go.shape.int] not defined" and exits 1.
