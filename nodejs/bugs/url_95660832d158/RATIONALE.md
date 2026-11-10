# Re-introduced bug (upstream 95660832d158, "url: align url format behavior with browsers")

**Bug:** URL serialization derived the host from the overridable public `this.hostname` getter instead of the internal URL context. A subclass overriding `hostname` therefore changed serialized output (upstream: `href`/`toString`/`toJSON` via the old `format`).

**Adaptation:** In v26.13.0, `href`, `toString`, `toJSON` and `url.format` use the ada-computed `#context.href` / `bindingUrl.format`, so the old `ctx.host` / `this.hostname` hunk in the JS `format` no longer exists. The only remaining JS serialization that composes a host is the `origin` getter, so the defect is re-expressed there.

**Hunk (lib/internal/url.js, `get origin`)**: for special schemes, `${protocol}//${this.host}` became `${protocol}//${this.hostname}` plus `:port` when present. This corresponds to the fix's `ctx.host` -> `this.hostname` hunk reversed: the host now comes from the overridable getter. Without an override, output is identical.

**Failing test:** `parallel/test-whatwg-url-override-hostname`, at the `url.origin` assertion:
`Expected values to be strictly equal: + 'http://bar.com' - 'http://foo.com'`.
Failed in two consecutive runs. `test-whatwg-url-custom-properties` still passes.
