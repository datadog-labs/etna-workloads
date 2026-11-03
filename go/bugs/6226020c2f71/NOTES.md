`repro.sh` builds and runs a program that passes a struct field of type `rune` to `fmt.Printf("%c", ...)`.

- go-clean: prints `T main`.
- go-buggy: the linker panics with `R_USEIFACE in main.main references type:rune which is not a type or itab`.

The injection stops `LinkString` (fmtTypeID mode) from collapsing `byte`, `rune` and `any` to their real types. The compiler then refers to a `type:rune` symbol that is never emitted, because the runtime type for `rune` is `type:int32`. The linker's deadcode pass hits that dangling reference and panics.

The output is filtered through `head -3` because the goroutine trace contains addresses that change between runs. Both toolchains were run with a separate `GOCACHE` each. A shared cache gave wrong results between them.
