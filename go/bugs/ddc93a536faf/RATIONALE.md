# Rationale

Fix hunk reversed: `noder/reader.go` `shapify` (now `Shapify`). The fix replaced the
unconditional `base.Assertf(targ.Kind() != types.TFORW, ...)` with a branch that tolerates
fully-instantiated TFORW type arguments (returning `targ` if it has a shape, otherwise
continuing). I restored the original unconditional assertion in `Shapify`
(src/cmd/compile/internal/noder/reader.go). The `Debug.Shapify` flag in base/debug.go is
left in place; it is only a debug print and has no behavioural effect.

Failing oracle cases: all three files (issue54722.go, issue54722b.go, nested.go) fail.
In go1.27.3 the failure appears while building std: `sync.entry[go.shape.interface {},...]
is missing its underlying type` (internal compiler error), so the testdir run fails to build.
This is the same crash the fix guarded against (assertion on a recursive instantiated TFORW
type argument). I tried a narrower variant that kept only the shaped early return. It built
std and passed all oracle cases, so go1.27.3 only reaches the TFORW case through shaped
types, and the plain assertion is the faithful revert.
