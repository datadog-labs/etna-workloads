# Re-introduced bug: std::stoull throws on malformed unsigned-integer option

**Bug.** For `kUInteger` options (e.g. `--cpu-prof-interval crashme`), the options parser
used `std::stoull(value)`, which throws `std::invalid_argument` on malformed input. Node is
meant to report a bad value cleanly, so the uncaught C++ exception calls `std::terminate`
and the process aborts (signal/`terminate called after throwing ...`) instead of exiting
with the normal "bad option" status 9. Upstream fix: nodejs/node#46290.

**Hunk (src/node_options-inl.h, `OptionsParser<Options>::Parse`, `case kUInteger`).**
The fix replaced `std::stoull(value)` with `std::strtoull(value.c_str(), nullptr, 10)`.
In v26.13.0 that line now sits in the non-strict (`!info.strict`) branch of `kUInteger`
(a strict `std::from_chars` branch was added later and is left untouched). I reverted the
non-strict branch to `std::stoull(value)`, restoring the throwing behaviour for options such
as `--cpu-prof-interval`, which is non-strict.

**Failing test.** `sequential/test-cpu-prof-invalid-options` fails (stable over 2 runs):
```
terminate called after throwing an instance of 'std::invalid_argument'
  what():  stoull
AssertionError [ERR_ASSERTION]: Expected values to be strictly equal:
null !== 9   (test-cpu-prof-invalid-options.js:75)
```

Note: the first incremental build crashed node_mksnapshot because of stale objects in
out/Release/obj.target/node_base (env.h layout mismatch, unrelated to this change); I deleted
those objects and rebuilt, which fixed it. No build files or tests were changed.
