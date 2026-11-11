# Rationale
File: ocaml/lambda/simplif.ml (today's location of bytecomp/simplif.ml), function simplify_exits. Two edits:

1. Pass 1, `Lstaticcatch (l1,(i,[]),Lstaticraise (j,[]))`: `incr_exit j ic.count ic.max_depth`, dropping `try_depth` from the max.
   Reverses fix hunk `@@ -133,25 +142,20 @@ let simplify_exits lam` (exit depth tracking when i is replaced by j).
   Note: I left this one unchanged in the end (it is the original code, as in the fix's "+" side).
   (Final state: unchanged from release.)
2. Pass 2, `Lstaticcatch (l1,(i,xs),l2)`: the inlining condition `count = 1 && max_depth <= try_depth` became
   `count = 1 && (max_depth <= try_depth || List.length xs > 1)`, and the `assert(max_depth = try_depth)` was removed.
   Reverses hunk `@@ -273,15 +278,23 @@ let simplify_exits lam`, which added the "not nested within an inner try..with" check.
   A fully unconditional revert made stdlib fail to build (warning 51 on in_channel.ml), so the revert is
   limited to handlers with several parameters (the tuple-binding case of MPR#7680).

Result: handler of a multi-var staticcatch gets inlined inside a try..with, so MPR#7680 test in
asmcomp/bind_tuples.ml (`let (a,b) = try (1,2) with _ -> ... in raise Not_found`) fails.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), `sh run-oracle.sh`: bind_tuples.ml => failed (Assertion failed at the MPR#7680 test, line 40).
