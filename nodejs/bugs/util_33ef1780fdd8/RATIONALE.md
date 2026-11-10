# util: show SuppressedError's error/suppressed properties on inspect

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 33ef1780fdd8717f6ce299df0812ea6ffc705f7e applied to v26.13.0 (clean).

Upstream commit message:

```
util: show SuppressedError's error/suppressed properties on inspect

util.inspect() (and console.log()) silently dropped a SuppressedError's
`error` and `suppressed` properties, the two pieces of information
needed to actually debug a disposal failure. Both properties are
non-enumerable, so they never showed up without this.

formatError() already special-cases two other non-enumerable
"container" properties for the same reason: Error's `cause` (#41002)
and AggregateError's `errors` (#43646). Handle SuppressedError's
`error` and `suppressed` the same way; nested SuppressedErrors (from
multiple failed disposals) are shown recursively since inspect()
already recurses into any Error-valued property.

Fixes: https://github.com/nodejs/node/issues/66033

Signed-off-by: agape1225 <49804691+agape1225@users.noreply.github.com>
PR-URL: https://github.com/nodejs/node/pull/66159
Fixes: https://github.com/nodejs/node/issues/66033
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
Reviewed-By: Jordan Harband <ljharb@gmail.com>
```
