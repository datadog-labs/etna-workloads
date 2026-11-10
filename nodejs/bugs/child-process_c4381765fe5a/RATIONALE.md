# child_process: clear timeout timer on spawn-time error too

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit c4381765fe5a45f7f972ecde98e2b970e429c4a5 applied to v26.13.0 (clean).

Upstream commit message:

```
child_process: clear timeout timer on spawn-time error too

When spawn() fails at the OS level (ENOENT, EACCES, EAGAIN, EMFILE,
ENFILE), the resulting ChildProcess only ever emits 'error', never
'exit'. The `timeout` option's cleanup only listened for 'exit', so
the timer stayed armed for the full `timeout` duration on any
spawn-time failure, holding the event loop open well after the
promise/callback had already settled via 'error'.

Clear the timer on 'error' as well as 'exit'.

Fixes: https://github.com/nodejs/node/issues/65504
Signed-off-by: kishore280 <maheshwarankishore@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65506
Reviewed-By: Aviv Keller <me@aviv.sh>
Reviewed-By: Stefan Stojanovic <stefan.stojanovic@janeasystems.com>
Reviewed-By: Luigi Pinca <luigipinca@gmail.com>
Reviewed-By: Antoine du Hamel <duhamelantoine1995@gmail.com>
```
