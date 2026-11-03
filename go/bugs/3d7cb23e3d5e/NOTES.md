`repro.go` prints the types of a `[]any`, a `*any` and a `[]*any`, and converts the first two to interfaces.

The buggy compiler no longer emits the `any` type descriptors when it compiles the runtime. Any program that needs the `[]any` descriptor then fails at link time.

- go-clean: runs and prints `[]interface {} *interface {} []*interface {}` and `false false`, exit 0.
- go-buggy: the linker panics with "R_USEIFACE in main.main references type:[]interface {} which is not a type or itab", exit 1.

The upstream test (`issue49619.go`) is a `// build` test that the harness never runs, and it builds fine on both toolchains here. I used a different program.
