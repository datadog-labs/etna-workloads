# lib: disable default memory leak warning for AbortSignal

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c1ccade02f29fd5585601bd496d4fb615a55b682 applied to v26.13.0 (clean).

Upstream commit message:

```
lib: disable default memory leak warning for AbortSignal

This change sets the default `kMaxEventTargetListeners` property for
`AbortSignal` instances to 0, disabling the check per default, to
enable users to write isomorphic library code.
If desirable, the max event target listeners check can still be
enabled for individual `AbortSignal` instances by calling
`setMaxListeners` on them.

Refs: https://github.com/nodejs/node/issues/54758
PR-URL: https://github.com/nodejs/node/pull/55816
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
