# Rationale

Fix (antirez/mattsta, 2014): blocking list ops missed lists created internally
(SORT..STORE, MOVE, RENAME, ...) because the "list is ready" signal was only
raised by the push commands; the fix moved it into dbAdd.

Changes (pre-fix behaviour restored):
- `src/db.c` dbAddInternal: no longer signals a newly added OBJ_LIST key as ready
  (reverses the fix's move of the signal into dbAdd). Other types are unchanged.
- `src/t_list.c` pushGenericCommand and lmoveHandlePush: signal the key as ready
  right after creating it, as the pre-fix code did in LPUSH/RPUSH/RPOPLPUSH.

Effect: BLPOP/BLMOVE/BLMPOP clients blocked on a key that later appears via SORT STORE,
MOVE, RENAME, RESTORE, COPY, SWAPDB etc. are never woken. Oracle cases such as
"BLPOP when result key is created by SORT..STORE", "BLPOP when new key is moved into place"
and "SWAPDB awakes blocked client" are expected to fail (hang/time out).
