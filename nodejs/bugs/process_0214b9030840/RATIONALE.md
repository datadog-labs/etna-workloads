# process: fix two overflow cases in SourceMap VLQ decoding

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0214b90308404b18efd60ce07cb89014073ee161 applied to v26.13.0 (clean).

Upstream commit message:

```
process: fix two overflow cases in SourceMap VLQ decoding

These both have to do with extremely large numbers, so it's unlikely to
cause a problem in practice. Still, correctness.

First, encoding `-2147483648` in VLQ returns the value `"B"`. When
decoding, we get the value `1` after reading the base64. We then check
if the first bit is set (it is) to see if we should negate it, then we
shift all bits right once. Now, `value` will be `0` and `negate` will
be `true`. So, we'd return `-0`. Which is a bug! `-0` isn't
`-2147483648`, and we've broken a round trip.

Second, encoding any number with the 31st bit set, we'd return the
opposite sign. Let's use `1073741824`. Encoding, we get `"ggggggC"`.
When decoding, we get the value `-2147483648` after reading the base64.
Notice, it's already negative (the 32nd bit is set, because the 31st was
set and we shifted everything left once). We'd then check the first bit
(it's not) and shift right. But we used `>>`, which does not shift the
sign bit. We actually wanted `>>>`, which will. Because of that bug, we
get back `-1073741824` instead of the positive `1073741824`. It's even
worse if the 32nd and 31st bits are set, `-1610612736` becomes
`536870912` after a round trip.

I recently fixed the same two bugs in Closure Compiler:
https://github.com/google/closure-compiler/commit/584418eb

PR-URL: https://github.com/nodejs/node/pull/31490
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ben Coe <bencoe@gmail.com>
Reviewed-By: David Carlier <devnexen@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
Reviewed-By: Gus Caplan <me@gus.host>
```
