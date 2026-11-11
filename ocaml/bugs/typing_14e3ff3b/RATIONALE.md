# Rationale
Hunk: ocaml/typing/includemod.ml, `modtypes_constraint` (today's name for `modtypes_with_shape`).
Changed direction from `Directionality.strictly_positive ~mark ~both:true` to `Directionality.unknown ~mark`, and removed the comment.
Reverses fix hunk `@@ -1330,7 +1330,8 @@ end` (unknown -> strictly_positive). The `~both:true` argument is how today's code spells that.
Commands: `make clean; make -j8; make -j8 ocamltest; sh run-oracle.sh`. Result: link_intf_impl.ml fails (the reference differs in the `<->` and `<-` arrows).
