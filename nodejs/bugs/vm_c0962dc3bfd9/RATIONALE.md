# Re-introduced bug: vm global named-property enumerator no longer distinguishes named vs indexed keys

**Bug.** Before upstream fix c0962dc3 (PR 53517), the contextified global's named
property enumerator returned everything `GetPropertyNames` yields by default
(prototype chain included, enumerable only, symbols skipped, indices included),
instead of only own named (non-index) keys. Index keys therefore leaked through the
named enumerator and prototype-chain keys were reported as own keys of the vm global.

**Change (src/node_contextify.cc, `ContextifyContext::PropertyEnumeratorCallback`).**
Corresponds to the fix's hunk changing the named enumerator's `GetPropertyNames` call
(fix: kIncludePrototypes + ONLY_ENUMERABLE|SKIP_SYMBOLS + kSkipIndices; today's code:
kOwnOnly + ALL_PROPERTIES + kSkipIndices). I restored the pre-fix behaviour:
`KeyCollectionMode::kIncludePrototypes`, `ONLY_ENUMERABLE | SKIP_SYMBOLS`,
`IndexFilter::kIncludeIndices`. This restores the conflation of named and indexed
keys / own and prototype keys.

**Failing test.** `parallel/test-vm-global-property-enumerator` fails (`not ok`, stable
over repeated runs). The process aborts with a V8 fatal error
`Check failed: IsName(*element)`, because the named enumerator now returns numeric
index keys (e.g. for the array-sandbox cases), which V8 requires to be names.
`test-vm-global-property-prototype` still passes.
