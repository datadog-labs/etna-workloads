# Rationale

## Bug

The fix (commit 47bcc34271435e376b57a8482e06803f4a7a6c4f) addressed a NULL
pointer dereference in `sqlite3WindowLink()` (src/window.c). When a window
function appears in the ORDER BY clause of a compound SELECT that is the
body of a VIEW, and that VIEW is later referenced during an `ALTER TABLE ...
RENAME TO`, the parser can call `sqlite3WindowLink()` with `pSel == 0` (the
window term isn't actually attached to a real SELECT in this error path).
Before the fix, the function unconditionally dereferenced `pSel->pWin`,
crashing. The fix added a `pSel!=0` guard so the function becomes a no-op
when there's no Select to attach the window to.

## Hunk reversed

Fix hunk (src/window.c):
```
-  if( 0==pSel->pWin 
-   || 0==sqlite3WindowCompare(0, pSel->pWin, pWin, 0)
+  if( pSel!=0
+   && (0==pSel->pWin || 0==sqlite3WindowCompare(0, pSel->pWin, pWin, 0))
   ){
```

In version-3.54.1, `sqlite3WindowLink()` carries the same guard, but
expressed as a wrapping `if( pSel ){ ... }` block around the whole function
body (the code was reformatted since 2019, but the logic is identical to
what the fix introduced):

```c
void sqlite3WindowLink(Select *pSel, Window *pWin){
  if( pSel ){
    if( 0==pSel->pWin || 0==sqlite3WindowCompare(0, pSel->pWin, pWin, 0) ){
      ...
    }else{
      ...
    }
  }
}
```

I removed the `if( pSel ){ ... }` wrapper (un-indenting its body back to
function scope), restoring the pre-fix behavior of unconditionally
dereferencing `pSel->pWin` regardless of whether `pSel` is NULL. This is the
same defect the fix hunk reverses, just reformatted: both the original 2019
code and the pre-fix 3.54.1 code gate the entire dereference on `pSel`
being non-NULL; removing that gate in either form reintroduces the crash.

## Oracle result

Running `./check.sh` against test/window1.test: all cases up through
window1-31.3 pass, and then **window1-32.10** — the exact regression test
added by the fix (`CREATE VIEW a AS SELECT NULL INTERSECT SELECT NULL ORDER
BY s() OVER R; ... ALTER TABLE a0 RENAME TO S;`, Chromium issue 1025467) —
crashes the test process (the output stream ends abruptly mid-test with no
"Ok"/"FAILED" line), consistent with the NULL pointer dereference segfault
the fix was written to prevent.
