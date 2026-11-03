# Rationale

Fix reversed: "allow ITabLsym() to create a dummy itab even when the concrete type doesn't implement the interface" (reflect.go hunks).

In go1.27.3 the fix's `writeITab(..., allowNonImplement)` parameter and the zeroed-entry dummy itab code are still present, but now routed through `itabLsym(typ, iface, allowNonImplement)`. The one-line change in `src/cmd/compile/internal/reflectdata/reflect.go` makes `ITabLsym` call `itabLsym(typ, iface, false)` instead of `true`. This restores the pre-fix `writeITab(lsym, typ, iface)` call in `ITabLsym`, which hit `base.Fatalf("incomplete itab")` for non-implementing types.

Oracle: `Test/typeparam/issue50002.go` fails with `internal compiler error: incomplete itab` when compiling `F[byte, string]`.
