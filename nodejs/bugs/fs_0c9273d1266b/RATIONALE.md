# Re-introduced bug
Before the fix, the shared validator `validateStringAfterArrayBufferView` accepted non-primitive
objects with an own `toString` function (e.g. `{ toString() {...} }`) as "string" data, contrary to the docs.
Such objects then reach `binding.writeString`/`Buffer.from`, so `FileHandle.write`, `fsPromises.writeFile` and
`fs.writeSync` accept (or crash on) non-string objects instead of throwing `ERR_INVALID_ARG_TYPE`.

# Change (lib/internal/fs/utils.js only)
The fix introduced `validatePrimitiveStringAfterArrayBufferView` (strict `typeof === 'string'`) and switched
`fs.writeSync`, `promises.write` and `promises.writeFile` to it. In today's tree those call sites share the
single strict `validateStringAfterArrayBufferView`; I restored its pre-fix lenient body (string, or object with
own function `toString`, returns OK) and added the `ObjectHasOwn` primordial import. This reverts all three call sites at once
(and also fs.write/fs.writeFile, which used the lenient validator before the fix too).

# Failing tests
parallel/test-fs-promises-file-handle-write and parallel/test-fs-write: the new cases with
`{ toString() {...} }` are no longer rejected with ERR_INVALID_ARG_TYPE (assertion failures; stable over repeated runs).
