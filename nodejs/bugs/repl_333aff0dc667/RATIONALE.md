# Rationale

**Bug:** The module-level global `lineEnding` RegExp is shared by recursive `[kTtyWrite]` calls (a `line` handler calling `rli.write()`). Since `RegExpPrototypeExec` on a /g regex uses `lastIndex` state, the nested call clobbers the outer call's position, giving wrong/looping output (infinite loop in `.load`).

**Change (lib/internal/readline/interface.js, default branch of `[kTtyWrite]`):** one hunk, corresponding to the fix's single hunk. It removes `lineEnding.lastIndex = 0` (reset), removes the restore of `lineEnding.lastIndex = lastIndex` after `this[kLine]()`, and restores the pre-fix control flow (first exec, insert, loop calling kLine then insert, trailing `if (lastIndex === s.length) this[kLine]()`). Without the restore, the nested write leaves `lastIndex` at a stale value for the outer loop.

**Failing test:** parallel/test-readline-interface-recursive-writes:
`AssertionError: Expected values to be strictly equal: 3 !== 2` (stable across 2 runs).
