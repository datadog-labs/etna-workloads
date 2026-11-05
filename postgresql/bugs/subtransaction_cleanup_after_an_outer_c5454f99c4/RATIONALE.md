# Rationale

Changed hunk: src/backend/utils/mmgr/portalmem.c, AtSubAbort_Portals().

Traces to the fix.patch hunk in AtSubAbort_Portals that added the "maybe it was used in this
subtransaction?" branch (`portal->activeSubid == mySubid`). That branch moves activeSubid to the
parent, forces an ACTIVE upper-level portal to FAILED, and reattaches its resowner to the failed
subxact's resource owner. I removed the whole branch, so portals created in an outer subtransaction
but run in the aborting one are left untouched, as before the fix. A failed outer portal then keeps
its resources and its ACTIVE status through subtransaction cleanup, which brings back the bad cleanup.
The `myXactOwner` parameter stays but is now unused. The other fix hunks (MarkPortalActive and the
relcache changes) are left alone.

Failing oracle case: src/test/regress||transactions
