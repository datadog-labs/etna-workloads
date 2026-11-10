# Re-introduced bug: href setter has side effects when parsing fails

**Bug.** Before the fix, the `URL#href` setter installed a brand-new `URLContext` on the
URL *before* parsing, so when parsing threw (e.g. `url.href = ''`) the URL object was left
clobbered instead of unchanged (nodejs/node#24345).

**Adaptation.** The release uses ada (`bindingUrl.update`) and a private `#context`; the old
`parse()` wrapper and C++ `URL::Parse` whitespace code no longer exist, so the fix's
`lib/internal/url.js` hunks (dropping the wrapper, reusing the existing context) map onto
the `set href` hunk only. The C++ trimming hunk (`input = p;`) has no counterpart and is not touched.

**Hunk (lib/internal/url.js, `set href`)** corresponds to the fix's hunk replacing
`parse(this, input)` (which did `url[context] = new URLContext()` first) with a parse that reuses the
existing context. We re-add the pre-parse context replacement: a fresh `URLContext` is
installed before `bindingUrl.update`; it keeps only the scheme (href = `http:`) so the
clobbered state is observable (an empty href would make `assert.deepStrictEqual` skip its URL
href comparison, because `isURL` requires a truthy href). If `update` fails, the throw leaves the clobbered state.

**Failing test.** `parallel/test-whatwg-url-custom-href-side-effect`: `assert.deepStrictEqual(url, ref)`
fails after `url.href = ''` throws (href `http:` vs `http://example.com/path`).
Stable over two runs; `test-whatwg-url-custom-setters` still passes.
