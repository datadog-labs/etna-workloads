# Rationale

## Change

File: `ext/fts3/fts3_aux.c`, function `fts3auxNextMethod`, state-3 branch
(the branch that interprets a decoded varint as a column number read from
the `%_stat` record of an fts3aux shadow table).

Before (current 3.54.1 tree):

```c
iCol = (int)v;
if( iCol<1 || iCol>32767 ){
  rc = SQLITE_CORRUPT_VTAB;
  break;
}
```

After (reintroduced bug):

```c
iCol = (int)v;
if( iCol>32767 ){
  rc = SQLITE_CORRUPT_VTAB;
  break;
}
```

## Mapping to the fix hunk

The fix (`fix.patch`) added exactly one check to this function:

```c
iCol = (int)v;
+          if( iCol<1 ){
+            rc = SQLITE_CORRUPT_VTAB;
+            break;
+          }
if( fts3auxGrowStatArray(pCsr, iCol+2) ) return SQLITE_NOMEM;
```

In the 3.54.1 tree that same site now reads `if( iCol<1 || iCol>32767 )`,
because an upper-bound check (`iCol>32767`) was added by later, unrelated
work to guard against a different overflow in `fts3auxGrowStatArray`. The
fix's own lower-bound condition (`iCol<1`) is still present, merged into
that combined test. I removed only the `iCol<1` half, restoring the exact
pre-fix behaviour: a column number of 0 or negative, decoded from a
corrupt `%_stat` record, is no longer rejected. The upper-bound check is
untouched since it postdates this bug and guards an unrelated case.

## Effect

With the lower bound gone, a corrupt record can set `iCol` to 0 or
negative. Code right after the check does `aStat[iCol+1].nDoc++`, so
`iCol<1` drives that index to 0 or negative — either stomping the
`aStat[0]` totals slot unexpectedly or indexing before the start of the
array, corrupting memory.

## Oracle result

`./check.sh` was run against `test/fts3corrupt4.test`. Case `fts3corrupt4-52.1`
(added by this same fix, using a hand-crafted corrupt fts4aux hexdb) fails:
instead of returning the expected error `{1 {database disk image is
malformed}}`, the query against the corrupt `t1`/`t2` tables no longer
reports the corruption through this path, reproducing the crash/misbehaviour
class the fix addressed. All other pre-existing cases in the file continue
to pass.
