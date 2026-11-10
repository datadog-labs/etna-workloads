# trace_events: fix abort when Node.js does not own the V8 platform

Verbatim tier: the injection is the reverse of the implementation hunks of upstream commit 66fd78803dd915195354bb4f00f3dcd7d57a8801 applied to v26.13.0 (clean).

Upstream commit message:

```
trace_events: fix abort when Node.js does not own the V8 platform

Requiring `node:trace_events` and calling `createTracing()` aborted
the process, and `getEnabledCategories()` dereferenced a null pointer,
when Node.js runs on an embedder's own platform
(`kNoInitializeNodeV8Platform`): no `tracing::Agent` exists then, and
`lib/trace_events.js` only checked the compile-time `hasTracing` flag
and `ownsProcessState` before handing the null agent to the binding.

Have the binding report whether an agent exists and throw the existing
`ERR_TRACE_EVENTS_UNAVAILABLE` when it does not, as for a
`--without-v8-platform` build.

Refs: https://github.com/nodejs/node/pull/19803
Signed-off-by: Shelley Vohr <shelley.vohr@gmail.com>
PR-URL: https://github.com/nodejs/node/pull/65954
Reviewed-By: Chengzhong Wu <legendecas@gmail.com>
```
