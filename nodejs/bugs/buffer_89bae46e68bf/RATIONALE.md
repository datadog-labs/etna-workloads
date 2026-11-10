# buffer: fix unaligned UTF-16LE decoding

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 89bae46e68bfaa94666f628ea69282bf897b3f89 applied to v26.13.0 (clean).

Upstream commit message:

```
buffer: fix unaligned UTF-16LE decoding

For odd-length input, the destination only has room for complete code
units. Copy those units and ignore the trailing byte. This matches the
aligned and big-endian paths.

Assisted-by: pi
Signed-off-by: Matteo Collina <hello@matteocollina.com>
PR-URL: https://github.com/nodejs/node/pull/65905
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
Reviewed-By: Robert Nagy <ronagy@icloud.com>
```
