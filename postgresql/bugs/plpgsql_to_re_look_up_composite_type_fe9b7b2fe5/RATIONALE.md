# Rationale

Changed hunk: `src/backend/utils/cache/typcache.c`, function `TypeCacheRelCallback`
(now `invalidateCompositeTypeCache`-style code in the relcache-invalidation path).
It traces to the typcache.c hunk of fix.patch, which added `typentry->tupDesc_identifier = 0;`
when the cached tupdesc is released. I removed that reset.

Why it brings the bug back: plpgsql compares its saved `tupdesc_id` with the typcache entry's
`tupDesc_identifier` to decide whether a composite type was invalidated (for example dropped
and recreated). If the identifier is not cleared when the tupdesc is dropped, the check in
`revalidate_rectypeid` sees a matching id and skips the re-look-up of the type name.
plpgsql then keeps using a stale composite type OID.

Failing oracle case: `src/pl/plpgsql/src||plpgsql_record`
