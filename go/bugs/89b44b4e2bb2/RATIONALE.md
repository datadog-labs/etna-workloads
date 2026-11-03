# Rationale

Fix (CL 279352): `reassigned` in inl.go missed reassignments via channel receives
(OSELRECV, OSELRECV2, OAS2RECV), so devirtualization/inlining treated a variable as
never reassigned and devirtualized `i.M()` to the wrong concrete type.

In go1.27.3 the logic is spread over three places; all three are reverted to omit receive forms:

1. `ir/expr.go` `Reassigned`: case list `OAS2, OAS2FUNC, OAS2MAPR, OAS2DOTTYPE, OAS2RECV, OSELRECV2`
   -> `OAS2, OAS2FUNC, OAS2MAPR, OAS2DOTTYPE`. Reverses the fix's `OAS2RECV` / `OSELRECV2` additions.
   (OSELRECV no longer exists; `case i = <-b` is now an OAS2-style OSELRECV2.)
2. `ir/reassignment.go` `ReassignOracle.Init`: same list, same edit (the code comment says the two must stay in sync).
3. `devirtualize/devirtualize.go` `State.analyze`: `case ir.OAS2MAPR, ir.OAS2RECV, ir.OSELRECV2`
   -> `case ir.OAS2MAPR`. Today's devirtualizer (go126ImprovedConcreteTypeAnalysis = true) no longer
   calls `ir.StaticValue`/`Reassigned`; it records every assignment to an interface variable itself.
   This is the modern equivalent of the same defect: receive assignments are not seen as
   reassignments. Without this edit (1) and (2) alone did not make the oracle fail.

## Oracle
`test/fixedbugs/issue43292.go` fails: devirtualizes `i.M()` to `i.(A).M()` even though
`i` was reassigned from a channel, giving
`panic: interface conversion: main.I is main.B, not main.A`.
(TestShouldTest passes.)
