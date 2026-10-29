# Rationale

The fix (2006-06-14) renamed the error text "unknown module: %s" to "no such module: %s" in three places in vtab.c, and reworked xCreate error handling. In 3.54.1 the xCreate/xConnect error handling (`vtable constructor failed`, `did not declare schema`) is already in vtabCallConstructor, so only the message hunks can be reversed.

## Changes (src/vtab.c)
- `sqlite3VtabCallConnect` hunk (now line ~717, the `!pModule` branch of the connect path): message back to `unknown module: %s`.
- `sqlite3VtabCallCreate` hunk (the `!pModule` branch; in 3.54.1 this lives in `sqlite3VtabCallCreate`'s sibling at ~line 792, setting `*pzErr`): message back to `unknown module: %s`.
- The third hunk (sqlite3VtabFinishParse) has no equivalent in 3.54.1 and was not touched.

## Oracle failures
vtab1-1.1.1, 1.1.2, 1.10–1.15 and vtab1.2.6 fail: they expect `no such module: echo` and now get `unknown module: echo`.
