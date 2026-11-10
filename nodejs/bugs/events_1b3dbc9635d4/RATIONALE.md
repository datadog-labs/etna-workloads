# events: fix removeListener for Symbols

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 1b3dbc9635d45c83e355d312b6114d58664b1e7a applied to v26.13.0 (clean).

Upstream commit message:

```
events: fix removeListener for Symbols

Fix removeListener when eventName type is 'symbol'.

```js
const EventEmitter = require('events');
const myEmitter = new EventEmitter();
const sym = Symbol('symbol');
const fn = () => { };
myEmitter.on(sym, fn);

myEmitter.on('removeListener', (...args) => {
  console.log('removeListener');
  console.log(args, args[0] === sym, args[1] === fn);
});

myEmitter.removeAllListeners()
```

When the listener's eventName type is 'symbol' and removeListener is
called with no parameters, removeListener should be emitted.

PR-URL: https://github.com/nodejs/node/pull/31847
Reviewed-By: Anna Henningsen <anna@addaleax.net>
Reviewed-By: Colin Ihrig <cjihrig@gmail.com>
Reviewed-By: Ruben Bridgewater <ruben@bridgewater.de>
Reviewed-By: Shelley Vohr <codebytere@gmail.com>
Reviewed-By: Yongsheng Zhang <zyszys98@gmail.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
