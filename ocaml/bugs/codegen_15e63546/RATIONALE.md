# Rationale
One hunk, asmcomp/spill.ml, reversing `@@ -301,16 +301,13 @@ let rec spill i finally` of fix.diff.
- `| Iop op ->` back to `| Iop _ ->`, and `if operation_can_raise op then ... else ...` replaced by
  an ad-hoc `match i.desc with Icall_ind | Icall_imm | Iextcall | Ialloc -> union before1 spill_at_raise | _ -> before1`.
- The original ad-hoc list also had the two Icheckbound cases. I dropped them. On amd64 there is no
  Ishiftcheckbound, so keeping them leaves try_checkbound passing. Without them, the bounds-check op
  that can raise inside a try is missed by spilling, which is the same bug the fix addressed.
  Today's `operation_can_raise` also covers Ipoll, and that is missing from the list too.
Commands: `make clean && make -j8 && make -j8 ocamltest` (the clean build was split across calls because of a timeout), then `sh run-oracle.sh`.
Result: try_checkbound.ml fails (native compile fails); bytecode passes.
