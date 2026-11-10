# stream: propagate destruction in duplexPair

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit fbff28f7e699d0189040bde1aefbb9c33e6a5ff7 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: propagate destruction in duplexPair

Ensure destroying one side of a duplexPair triggers destruction of the
other side via process.nextTick(). Only the destruction signal is sent
to avoid breaking changes.

Fixes: https://github.com/nodejs/node/issues/61015
PR-URL: https://github.com/nodejs/node/pull/61098
Reviewed-By: Matteo Collina <matteo.collina@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
```
