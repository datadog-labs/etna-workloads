# Re-introduced bug: url.format double-brackets IPv6 hostnames

**Bug:** `url.format()` on an object whose `hostname` is already bracketed (e.g. `'[::]'`) wraps it in brackets again, giving `http://[[::]]/` instead of `http://[::]/`.

**Hunk (lib/url.js, `Url.prototype.format`):** corresponds to the fix's last hunk. The fix added `&& !isIpv6Hostname(this.hostname)` to the `includes(':')` check. In today's code that check is `StringPrototypeIndexOf(this.hostname, ':') !== -1`, so I removed `&& !isIpv6Hostname(this.hostname)`. Any hostname containing ':' now gets brackets, even if it is already bracketed. The `isIpv6Hostname` helper stays, because `parse` still uses it (the fix's other hunks refactor `parse`, so they aren't reverted).

**Failing test:** `parallel/test-url-format` reports `not ok` on both runs. The new `http://[::]/` case fails because the output has doubled brackets.
