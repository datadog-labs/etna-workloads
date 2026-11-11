# Adapted injection for allow mutating function args through `&raw const`

Fix: https://github.com/rust-lang/rust/commit/9c418e5170a2fb125ae260af1fd94e538201888d

# Rationale
File: compiler/rustc_mir_transform/src/deduce_param_attrs.rs, `DeduceParamAttrs::visit_place`.
Fix hunk `@@ -29,20 +29,31 @@ impl<'tcx> Visitor<'tcx> for DeduceReadOnly` added the arm
`PlaceContext::NonMutatingUse(NonMutatingUseContext::AddressOf) => { ... !place.is_indirect() }` marking the arg mutable
for `&raw const`. In 1.99.1 this is the `NonMutatingUseContext::RawBorrow` arm setting MUTATE|CAPTURE. I removed that arm
and put `RawBorrow` in the "Not mutating, so it's fine" list, restoring the pre-fix behaviour (readonly deduced despite &raw const).
