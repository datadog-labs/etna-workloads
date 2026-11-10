# stream: fix async iteration of undefined chunks

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 04e5c282a152a4159d2da22597d6a0b17c2e0cc8 applied to v26.13.0 (clean).

Upstream commit message:

```
stream: fix async iteration of undefined chunks

The hand-rolled async iterator introduced in
https://github.com/nodejs/node/pull/64447 unwraps thenable chunks
before delivering them, but guards the `then` access with
`chunk !== null` while the dereference itself requires `chunk != null`.
An object mode stream carrying an `undefined` chunk therefore threw

  TypeError: Cannot read properties of undefined (reading 'then')

Because the throw happens in a microtask rather than rejecting the
iterator's promise, it surfaces as an uncaught exception that
terminates the process instead of a catchable stream error.

`undefined` is a legal chunk value: doc/api/stream.md documents object
mode chunks as "any JavaScript value other than `null`" and reserves
`null` as the end-of-stream sentinel. `readable.push(undefined)`
returns true in object mode, so the stream accepts the value and then
crashes on the way out.

Read `then` with optional chaining at both sites so that `undefined` is
delivered as a value while `null` keeps signalling end-of-stream.
`then` is still read at most once, so a getter cannot observe a second
access.

Refs: https://github.com/nodejs/node/pull/64447
Assisted-by: a closed-source coding agent
Signed-off-by: Caleb ツ Everett <calebev@amazon.com>
PR-URL: https://github.com/nodejs/node/pull/65969
Reviewed-By: Xuguang Mei <meixuguang@gmail.com>
Reviewed-By: James M Snell <jasnell@gmail.com>
```
