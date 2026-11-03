# Rationale

Fix (issue 61992): expandCalls must marshal aggregate call arguments in the call's block, not the block where the argument value was created.

go1.27.3 rewrote expand_calls.go (storeArgOrLoad/storeOneLoad no longer exist). The equivalent code is `rewriteCallArgs`, which calls `decomposeAsNecessary(v.Pos, v.Block, a, mem, rc)`; `v.Block` is the call block. 

Change (src/cmd/compile/internal/ssa/expand_calls.go, rewriteCallArgs): pass `a.Block` instead of `v.Block`. This reverses the fix's `source.Block.NewValue*` -> `b.NewValue*` hunks: the selects, loads, offsets and stores are again created in the argument's block, so the memory chain gets threaded through a block other than the call's.

Oracle: test/fixedbugs/issue61992.go fails (and the compiler build of std fails) with "internal compiler error: two final stores - simultaneous live stores".
