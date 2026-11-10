# inspector: fix StringUtil::CharacterCount for unicodes

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 0edeafd73dd1c02c88b36282c1308901148d9d0e applied to v26.13.0 (fuzzy).

Upstream commit message:

```
inspector: fix StringUtil::CharacterCount for unicodes

`StringUtil::CharacterCount` should return the length of underlying
representation storage of a protocol string.

`StringUtil::CharacterCount` is only used in DictionaryValue
serialization. Only `Network.Headers` is an object type, represented
with DictionaryValue.

PR-URL: https://github.com/nodejs/node/pull/56788
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
Reviewed-By: Daniel Lemire <daniel@lemire.me>
Reviewed-By: Kohei Ueno <kohei.ueno119@gmail.com>
```
