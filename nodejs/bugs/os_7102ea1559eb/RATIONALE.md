# Rationale

Bug: `getCIDR` (lib/internal/util.js, used by `os.networkInterfaces()`) only checked that the
first non-all-ones netmask group was even (`(binary & 1) !== 0`) instead of checking that its
bits form a valid mask (ones followed by zeros). Invalid masks such as 242.0.0.0 (11110010) were
accepted and produced a bogus CIDR instead of `null`.

Hunk (lib/internal/util.js, getCIDR): the fix replaced `(binary & 1) !== 0` with
`StringPrototypeIncludes(binary.toString(2), '01')`. I restored the old condition
`(binary & 1) !== 0`. (The fix's move of the function from lib/os.js to internal/util is
already in the release, so only this condition is reverted; the now-unused
`StringPrototypeIncludes` import is left in place.)

Failing test: parallel/test-internal-util-getCIDR ("not ok"): `getCIDR('127.0.0.1','242.0.0.0','IPv4')`
returns '127.0.0.1/5' instead of null (and the IPv6 ffff:ff00:ffff:: case likewise). Ran twice, stable.
