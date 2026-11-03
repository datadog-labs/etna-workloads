# Rationale

Fix: stop marking the map-literal key/value arrays (`tk`, `te`) noalg in `maplit`.

1. `src/cmd/compile/internal/walk/complit.go` (`maplit`): reverses the fix hunk.
   The `TODO(#47904)` comment is replaced by `tk.SetNoalg(true)` / `te.SetNoalg(true)`, which is the pre-fix code.
2. `src/cmd/compile/internal/types/type.go` (`NewPtr`): removes the `if elem.Noalg() { t.SetNoalg(true); t.alg = ANOALG }` block.
   Re-adding the noalg marks (hunk 1) alone doesn't bring the bug back, because go1.27.3's `NewPtr` makes a pointer inherit noalg from its element. That inheritance covers the case the fix addressed. The pre-fix compiler didn't have it, so `*[N]T` was an ordinary type pointing to a noalg array type. Removing it is the same defect.

Failing oracle case: `Test/fixedbugs/issue47068.go` panics with `[30]int types do not match`. The 30-entry map literal in package `a` creates a noalg `[30]int` type. `reflect.TypeOf([30]int{})` and `reflect.TypeOf(new([30]int)).Elem()` then resolve to different type descriptors.
