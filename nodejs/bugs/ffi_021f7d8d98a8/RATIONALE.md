# ffi: accept safe integer numbers for 64-bit arguments

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 021f7d8d98a8acce6b7f5580ed11319f69a41c47 applied to v26.13.0 (clean).

Upstream commit message:

```
ffi: accept safe integer numbers for 64-bit arguments

Allow safe integer numbers as int64 and uint64 arguments alongside
bigint values. Reject negative numbers for uint64 and numbers outside
the safe integer range. Keep 64-bit return values as bigint.

Apply validation and conversion across the Fast API, shared-buffer,
and generic argument conversion paths.

Add coverage for Number and BigInt boundaries, invalid inputs, and
single-argument calls before and after optimization.

Signed-off-by: HoonDongKang <d159123@naver.com>
Assisted-by: Codex:Astra-medium
PR-URL: https://github.com/nodejs/node/pull/66197
Fixes: https://github.com/nodejs/node/issues/66198
Reviewed-By: Daeyeon Jeong <daeyeon.dev@gmail.com>
Reviewed-By: Paolo Insogna <paolo@cowtech.it>
```
