# Adapted injection for Actually, stop making any assumption about the projections applied to the upvar

Fix: https://github.com/rust-lang/rust/commit/54a93ab11e183e25ba9addc50655cf16e2614329

# Rationale
File: compiler/rustc_mir_transform/src/coroutine/by_move_body.rs, `MakeByMoveBody::visit_place`.
Re-adds the pre-fix assumption about projections left on the upvar after peeling the deref
(fix hunk `@@ -302,20 +302,18 @@`, removed lines:
`std::assert_matches::assert_matches!(final_deref, [] | [mir::ProjectionElem::Deref]);`).
Implemented as `assert!(matches!(final_projections, [] | [Deref]))` (assert_matches path is unavailable now).
The other fix hunks were renames/refactors only, already in 1.99.1 form.
