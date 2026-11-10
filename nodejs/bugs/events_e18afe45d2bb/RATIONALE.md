# events: fix add-remove-add case in EventTarget

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit e18afe45d2bb035434b8aac31375a9a15a605c9e applied to v26.13.0 (clean).

Upstream commit message:

```
events: fix add-remove-add case in EventTarget

Make sure that listeners are added properly if there has previously
been one but currently are none for a given event type.

PR-URL: https://github.com/nodejs/node/pull/34056
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Rich Trott <rtrott@gmail.com>
```
