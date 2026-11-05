# Rationale

File: src/backend/catalog/objectaddress.c, function getObjectIdentityParts(), case EventTriggerRelationId.

Traces to the single hunk of fix_impl.patch. The fix removed the "no objname support here" `*objname = NIL` and instead set `*objname = list_make1(evtname)`.
I reverted that: the event trigger name is no longer returned in objname (it is set to NIL), and the `evtname` local is removed. The identity string is still built, but pg_identify_object_as_address() gets an empty name list for event triggers, so it returns wrong or empty results.

Failing oracle cases:
- src/test/regress||event_trigger
