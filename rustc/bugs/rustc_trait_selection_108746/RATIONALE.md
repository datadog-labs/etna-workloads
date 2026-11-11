# Adapted injection for Don't project to RPITIT that has no default value

Fix: https://github.com/rust-lang/rust/commit/7634c5916a056c8a448101a309d9d9d61a6b3c26

# Hunk: compiler/rustc_trait_selection/src/traits/project.rs, confirm_impl_candidate
Fix hunk `@@ -2200,7 +2200,8 @@ fn confirm_impl_trait_in_trait_candidate`: added `|| !leaf_def.item.defaultness(tcx).has_value()` ("Also don't try to project to an RPITIT that has no value").
In 1.99.1 the RPITIT candidate was merged into the generic impl candidate; the equivalent check is `if !assoc_term.item.defaultness(tcx).has_value()`. I re-injected the bug by exempting RPITITs (`!tcx.is_impl_trait_in_trait(assoc_item_id)`), so projection proceeds to type_of on a value-less RPITIT, hitting the span_bug in type_of.rs (that hunk of the fix is already present in 1.99.1 and left unchanged).
