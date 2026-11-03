# Rationale

Fix (go.dev/cl/363314, #49516): `stencil.go` `buildClosure` did not set `IsDDD` on the call it built
for a function-instantiation closure, so a variadic target's args mismatched its signature.
stencil.go no longer exists in go1.27.3 (unified IR). The equivalent synthesized call to an
instantiated function is `syntheticTailCall` in `src/cmd/compile/internal/noder/reader.go`.

Change: `typecheck.Call(pos, fn, args, fn.Type().IsVariadic())` -> `typecheck.Call(pos, fn, args, false)`.
This reverses the fix's `IsDDD = typ.IsVariadic()`: the wrapper's call no longer marks the final
argument as a `...` spread, so a variadic callee receives a `[]T` where `T` is expected.

Oracle: test/typeparam/issue49516.go fails (both cases). The compiler reports the argument/signature
mismatch the fix describes ("cannot use slices.v (type []byte) as type go.shape.uint8 in argument to
slices.Insert[...]"). It hits the stdlib build (slices) first, so the testdir run fails to build.
