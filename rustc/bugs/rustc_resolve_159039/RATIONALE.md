# Adapted injection for resolve: fix effective visibilities for items in ambiguous glob sets

Fix: https://github.com/rust-lang/rust/commit/299a71d751139b1f269cd0f888b4f409f1505890

# Rationale
File: compiler/rustc_resolve/src/effective_visibilities.rs, fn `update_decl_chain` (called from `set_bindings_effective_visibilities`).

The fix generalised the one-level `ambiguity_vis_max` update in `update_import` into a recursive walk of the whole reexport chain (`update_decl_chain` recursing into `ambiguity_vis_max` at every hop, with a `seen_most_visible` cycle guard). I restored the old one-level behaviour: inside the chain loop, `ambiguity_vis_max` is only passed to `update_import` once, and the chain behind it (and its final definition) is not walked. The most visible route therefore never raises the def's effective visibility.
The `seen_most_visible` set is left in the signature but is now unused.
