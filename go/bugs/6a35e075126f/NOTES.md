repro.go is upstream test/typeparam/eface.go. It converts between generic interface I[T] and the equivalent non-generic interface{ foo() } inside generic functions.
Clean: no output, exit 0. Buggy: prints "test 5..8 failed", because the OCONVNOP-to-OCONVIFACE rewrite in noder/reader.go is removed, so the itabs are wrong and the comparisons fail.
