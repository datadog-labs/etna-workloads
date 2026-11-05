# Rationale

Changed file: `src/backend/utils/adt/arrayfuncs.c`.

I reverted the overflow-checked dimension arithmetic introduced by the fix back to the
original unchecked arithmetic, in each of the three functions touched by
`fix_impl.patch`'s `arrayfuncs.c` hunks. I did not revert the `arrayutils.c` /
`array.h` hunks (moving the `MaxArraySize` macro) since that part is cosmetic and
does not affect behavior.

## Hunk 1: `array_set_element`, lower-bound branch

Traces to `fix_impl.patch` hunk 1 (first hunk in `array_set_element`).

Before (buggy, restored):
```c
addedbefore = lb[0] - indx[0];
dim[0] += addedbefore;
```
This recomputes `dim[0]` via plain `int32` addition with no overflow check, same as
pre-fix code. If `indx[0]` is very negative (e.g. `INT32_MIN`), `lb[0] - indx[0]` can
overflow, and `dim[0] += addedbefore` can wrap into a small or negative number,
defeating the later array-size sanity checks and leading to undersized allocation /
memory corruption.

## Hunk 2: `array_set_element`, upper-bound branch

Traces to `fix_impl.patch` hunk 2 (second hunk in `array_set_element`).

Before (buggy, restored):
```c
addedafter = indx[0] - (dim[0] + lb[0]) + 1;
dim[0] += addedafter;
```
Same issue: with `indx[0]` near `INT32_MAX`, `indx[0] - (dim[0]+lb[0]) + 1` or the
subsequent `dim[0] += addedafter` can overflow silently.

## Hunk 3 & 4: `array_set_element_expanded`, lower- and upper-bound branches

Trace to `fix_impl.patch`'s corresponding hunks in `array_set_element_expanded`
(this logic is required to mirror `array_set_element`). Reverted to the same
unchecked `addedbefore`/`addedafter`/`dim[0] +=` arithmetic as above.

## Hunk 5 & 6: `array_set_slice`, lower- and upper-bound branches

Trace to `fix_impl.patch`'s hunks in `array_set_slice`. Restored the original
unchecked computation and also restored the original placement of the
`newhasnulls` test (`upperIndx[0] < lb[0] - 1` / `lowerIndx[0] > (dim[0] + lb[0])`),
since the fix had reordered that test to run after the (now-checked) dimension
update using `addedbefore`/`addedafter`. This reproduces the original unchecked
overflow in slice-assignment dimension growth as well.

## Why this brings back the bug

In all three functions, extending an array's dimension in response to an
out-of-range subscript now again uses raw `int32` arithmetic with no overflow
detection. A sufficiently extreme subscript (near `INT32_MIN`/`INT32_MAX`) can make
the new `dim[0]` wrap around instead of triggering the
"array size exceeds the maximum allowed" error, which is exactly the integer
overflow bug that upstream commit 18b585155a89 fixed.

## Oracle verification

Ran `python3 <tools>/agent_oracle.py`:

- `src/test/regress||arrays` — **FAIL** (the only oracle case, and it fails as required).
