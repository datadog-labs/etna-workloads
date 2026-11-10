# http2: fix memory leak caused by premature listener removing

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fb8de039c9ef97dc3bdd237d8711d8b3d911f265 applied to v26.13.0 (clean).

Upstream commit message:

```
http2: fix memory leak caused by premature listener removing

Http2Session should always call ondone into JS to detach the
handle. In some case, ondone is defered to be called by the
StreamListener through WriteWrap, we should be careful of this
before getting rid of the StreamListener.

PR-URL: https://github.com/nodejs/node/pull/55966
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Juan José Arboleda <soyjuanarbol@gmail.com>
```
