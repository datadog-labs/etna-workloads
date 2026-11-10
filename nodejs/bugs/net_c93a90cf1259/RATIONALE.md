# net: fix BlockList.fromJSON for IPv4-mapped IPv6 rules

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c93a90cf125900178bda494af5ea34cff3b203df applied to v26.13.0 (clean).

Upstream commit message:

```
net: fix BlockList.fromJSON for IPv4-mapped IPv6 rules

BlockList.toJSON() serializes IPv4-mapped IPv6 addresses in mixed
dotted-quad form (e.g. "::ffff:192.0.2.128"), but the fromJSON() rule
parser's IPv6 regexes excluded "." and capped the length at 39, so such
rules were silently corrupted or dropped on a toJSON()/fromJSON()
round-trip. Allow "." and raise the cap to 45 (the longest mixed form).

Signed-off-by: Daijiro Wachi <daijiro.wachi@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/64125
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Richard Lau <richard.lau@ibm.com>
```
