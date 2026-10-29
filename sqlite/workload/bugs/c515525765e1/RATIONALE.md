# Ticket #2154 re-injection

Fix: sqlite3Reprepare used to call sqlite3VdbeSwapOps (swap only aOp/nOp); the fix swapped the whole Vdbe and transferred bindings.

Changes in tree/:
- src/vdbeaux.c: `sqlite3VdbeSwap` body replaced by the old `sqlite3VdbeSwapOps`, which swaps only `aOp` and `nOp`. All other state (nMem, nCursor, nVar/aVar, apCsr, expmask, prepFlags, etc.) stays with the old statement and no longer matches the new bytecode. Reverses the vdbeaux.c hunk.
- src/vdbe.h: prototype renamed to `sqlite3VdbeSwapOps`. Reverses the vdbe.h hunk.
- src/prepare.c (sqlite3Reprepare): call `sqlite3VdbeSwapOps(pNew, p)` and drop the `sqlite3TransferBindings` call. Reverses the prepare.c hunk.

Oracle: capi3c-17.4 (reprepare after CREATE INDEX) hits the assertion `p->apCsr[i]==0` in sqlite3VdbeReset, because the cursor count/array no longer matches the new program. The run aborts there, so the later cases (17.x, including the binding cases 17.10-17.18) don't run.
