# Rationale

In REL_18_6 the permission checks live in `inv_open()`, so the fix's explicit check in `be_lo_put()` was refactored away. I restored the old structure, where `inv_open()` does not do the write check and lo_put() has none.

- `src/backend/storage/large_object/inv_api.c`, `inv_open()`: removed the ACL_UPDATE check, and made the ACL_SELECT check depend on `flags & INV_READ` instead of `descflags & IFS_RDLOCK`. INV_WRITE no longer implies a SELECT check. This traces to the fix hunk in `be_lo_put()`, which added the missing UPDATE check for lo_put().
- `src/backend/libpq/be-fsstubs.c`, `be_lo_open()`: added the UPDATE check after `inv_open()` for INV_WRITE opens, so lowrite() is still protected. This is the same check text as the fix hunk, in the caller that still needs it. `be_lo_put()` goes without it, which is the original bug: lo_put() needs no permission on the object.

Failing oracle case: `src/test/regress||privileges`. `lo_put(1002, ...)` by a user without privileges now succeeds instead of failing with "permission denied for large object 1002".

Side effect: lo_open(INV_WRITE) no longer requires SELECT, only UPDATE. I did not check whether the second privileges.out diff, a following `loread` that now returns data, is caused by the lo_put write going through or by this change.
