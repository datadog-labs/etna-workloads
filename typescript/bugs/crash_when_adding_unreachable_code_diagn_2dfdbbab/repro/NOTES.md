Input: an async generic function with a malformed parameter (`asyncIterable!: ...`), which produces missing nodes, followed by a `for await` loop and a `return`.
run.cjs creates a program with allowUnreachableCode:false and prints syntactic and semantic diagnostics.
Clean: prints the diagnostics normally. Injected: the unreachable-code check uses node.pos/end of missing nodes, so output differs (error or crash in the reachability diagnostic).
