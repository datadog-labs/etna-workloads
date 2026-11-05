# Rationale
File: src/backend/catalog/objectaddress.c (both hunks trace to fix_impl.patch).

1. getObjectDescription, case PublicationRelRelationId: back to
   "publication table %s in publication %s" with get_rel_name() instead of
   getRelationDescription() (so no schema-qualification / relkind wording).
2. getObjectIdentityParts, case PublicationRelRelationId: identity uses the
   unqualified get_rel_name() text, and getRelationIdentity/objargs are only
   done when objname is set (the old code tested objname but wrote *objargs).

The fix's comment-only hunk on getRelationDescription is not reverted.

Failing oracle case: src/test/regress||object_address
