repro.sh compiles a package that calls unsafe.Add and unsafe.Slice with `-gcflags=-lang=go1.16`.

- go-clean rejects both calls with "unsafe.Add/Slice requires go1.17 or later" and exits 1.
- go-buggy accepts them silently and exits 0.
