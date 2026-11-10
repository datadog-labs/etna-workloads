# Adapted injection for Improve parse errors for lifetimes in type position

Fix: https://github.com/rust-lang/rust/commit/8887af72a0b1f37a34b02d488ca3278576e2d73d

# Rationale
In 1.99.1 the diagnostics live in compiler/rustc_parse/src/diagnostics.rs (not errors.rs/messages.ftl; messages are inline).

1. diagnostics.rs, `NeedPlusAfterTraitObjectLifetime`: restores old message "lifetime in trait object type must be followed by `+`" and removes the `suggestion` field/`+ /* Trait */` help.
   Re-expresses fix hunks `@@ -2806,6 +2806,8 @@ ... NeedPlusAfterTraitObjectLifetime` (added `suggestion: Span`) and messages.ftl `@@ -642,7 +642,9 @@` (new message + `.suggestion`).
2. parser/ty.rs, `parse_bare_trait_object`: restores the old body (`lt_no_plus = check_lifetime() && !look_ahead(1, is_like_plus)`, parse bounds, emit error with only `span: lo`), dropping the edition-2021 "expected type, found lifetime" recovery to a reference type. Re-expresses `@@ -425,12 +428,60 @@ fn parse_bare_trait_object`. `maybe_recover_ref_ty_no_leading_ampersand` is left (now unused, a dead-code warning).
