# Adapted injection for Use fulfillment, not evaluate, during method probe

Fix: https://github.com/rust-lang/rust/commit/ff4653a08f0c9dad1db927727e102c51f0ea39b2

# Rationale
File: compiler/rustc_hir_typeck/src/method/probe.rs, fn `consider_probe`, `InherentImplCandidate` arm.

The impl's where-clause obligations used to be registered in the ObligationCtxt, so fulfillment decided them.
They are now checked one by one with `infcx.predicate_may_hold(&o)` (evaluation). A failure sets `NoMatch` and
pushes to `possibly_unsatisfied_predicates`.

This re-expresses the fix's central change, the move from `predicate_may_hold` / evaluate to
`ocx.register_obligations` + `select_where_possible`. In fix.diff that is the removed lines of the form
`-  if !self.predicate_may_hold(&o) {` against the added `+  for error in ocx.select_where_possible() {`
(around the @@ hunks at probe.rs ~1439-1523). The other hunks (Candidate refactor, demand.rs) are not
reintroduced. Only the inherent-impl path was reverted.
