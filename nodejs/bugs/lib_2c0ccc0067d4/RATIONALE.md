# lib: fix for FileHandle.readableWebStream

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 2c0ccc0067d4f932bc7a37d473dc188841193a75 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: fix for FileHandle.readableWebStream

Fixes FileHandle.readableWebStream in mode "byob" when reading into
a view that has a byteOffset>0 into the underlying ArrayBuffer.

Fixes: https://github.com/nodejs/node/issues/58817
Signed-off-by: Patrick Dähne <pdaehne@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/58842
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: Zeyu "Alex" Yang <himself65@outlook.com>
Reviewed-By: LiviaMedeiros <livia@cirno.name>
Reviewed-By: Filip Skokan <panva.ip@gmail.com>
```
