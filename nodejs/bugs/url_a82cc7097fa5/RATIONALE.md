# url: align URLPatternInit dictionary conversion with WebIDL

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit a82cc7097fa56dec70f24edb8e4f05e6b98c8048 applied to v26.13.0 (clean).

Upstream commit message:

```
url: align URLPatternInit dictionary conversion with WebIDL

Read URLPatternInit dictionary members in lexicographical order so
getters and proxy traps observe the access sequence required by WebIDL.
Use sparse dictionary template values so URLPatternResult inputs only
expose members present after WebIDL conversion.

Fixes: https://github.com/nodejs/node/issues/64780
Signed-off-by: piyushrajyadav <piyushyadavrajyadav@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65498
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Yagiz Nizipli <yagiz@nizipli.com>
```
