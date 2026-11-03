# Rationale

Hunk: `src/cmd/compile/internal/reflectdata/reflect.go`, `WriteBasicTypes`.
The fix added `writeType(types.AnyType)` to the set of predefined types emitted
when compiling package runtime. In go1.27.3 the code builds a `list` of types
and writes `*T` and `*[]T` for each; `types.AnyType` was an element of that list.
I removed `types.AnyType` from the list, which restores the pre-fix omission.

Oracle: test/fixedbugs/issue49619.go (both cases) fail. The build of the
test fixture crashes in the linker: `R_USEIFACE ... references type:[]interface {}
which is not a type or itab`, since `[]any` is no longer emitted by runtime.
