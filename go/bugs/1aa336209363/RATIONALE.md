# Re-enable inlining of tail calls (reverses the revert, go.dev/issue/73747)

The fix reverted tail-call inlining. go1.27.3 still has that revert, so each hunk below undoes one revert hunk:

- noder/reader.go `addTailCall`: drops the `!unifiedHaveInlineBody(...)` condition for non-interface methods, so wrappers tail-call inlineable methods again (hunk: reader.go).
- inline/interleaved/interleaved.go: `match` no longer sets `NoInline` on TailCallStmt calls. `mark` goes back to `ir.EditChildren(n, s.mark)`. `unparenthesize` again turns an inlined tail call into a return, or a block plus return (three hunks). `inl.go`'s `NoInline` check is kept because bloop uses it.
- ir/stmt.go, ir/node_gen.go: `TailCallStmt.Call` is a `Node` again, so it can hold an `InlinedCallExpr`.
- ssagen/ssa.go, walk/stmt.go: cast `n.Call` to `*ir.CallExpr` where the field is used (walk casts once, since the code now also handles interface calls).
- typecheck/typecheck.go (OTAILCALL) and typecheck/stmt.go: drop the `.(*ir.CallExpr)` assertions that would panic on an `InlinedCallExpr`.

## Oracle
`test/tailcall.go` fails: the compiler now emits "tail call emitted for the method (*Foo).Get3Vals wrapper" for an inlineable method, which the test does not expect. `TestShouldTest` passes. The tree builds and the standard library compiles.
