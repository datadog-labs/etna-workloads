# stream: add bytes() method to stream/consumers

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 938f175dbeffe85ca9e96b88f9ee599fe80ea42d applied to v26.13.0 (clean).

Upstream commit message:

```
stream: add bytes() method to stream/consumers

- Add bytes() method to get Uint8Array from streams
- Add tests for bytes() method in PassThrough and ObjectMode scenarios
- Update documentation

Fixes: https://github.com/nodejs/node/issues/59542
PR-URL: https://github.com/nodejs/node/pull/60426
Reviewed-By: Ethan Arrowood <ethan@arrowood.dev>
Reviewed-By: René <contact.9a5d6388@renegade334.me.uk>
Reviewed-By: Jake Yuesong Li <jake.yuesong@gmail.com>
Reviewed-By: Mattias Buelens <mattias@buelens.com>
Reviewed-By: Benjamin Gruenbaum <benjamingr@gmail.com>
Reviewed-By: Gürgün Dayıoğlu <hey@gurgun.day>
```
