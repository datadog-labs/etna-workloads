# Reproducer notes

`repro.py` feeds `csv.reader` an iterator whose `__next__` re-enters the
same reader: on its first call it calls `next(reader)` again before
returning a data line. This is the re-entrant pattern from gh-145105.

On the inner call, `Reader_iternext_lock_held` runs out of input lines
(`StopIteration` from the underlying iterator mid-record) and frees
`self->fields`, leaving it `NULL`. Control then returns to the outer call,
which (on the fixed interpreter) checks `self->fields == NULL` right after
`PyIter_Next()` and raises `csv.Error("iterator has already advanced the
reader")`. The injected patch removes that guard, so the outer call
proceeds to use the freed/NULL `fields` list in `parse_save_field()` /
`PyList_Append`, crashing the process.

Observed with `./check.sh`:
- `python-clean`: exit 0, prints `csv.Error iterator has already advanced the reader`.
- `python-buggy`: exit -11 (SIGSEGV).
