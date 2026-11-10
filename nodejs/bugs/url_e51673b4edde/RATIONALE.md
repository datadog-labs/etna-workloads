# url: add Symbol.toStringTag to URLPattern

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e51673b4edded974d0b855374c34f46f99ba0563 applied to v26.13.0 (clean).

Upstream commit message:

```
url: add Symbol.toStringTag to URLPattern

Define Symbol.toStringTag on URLPattern.prototype so its class string
matches the Web IDL interface name.

Add coverage for the property descriptor and
Object.prototype.toString().

Fixes: https://github.com/nodejs/node/issues/65924
Signed-off-by: XadillaX <i@2333.moe>
PR-URL: https://github.com/nodejs/node/pull/65925
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: Jason Zhang <xzha4350@gmail.com>
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Jake Yuesong Li <jake.yuesong@gmail.com>
```
