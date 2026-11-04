# RATIONALE

## Changed hunk
`datafusion/functions/src/datetime/date_bin.rs`, `date_bin_nanos_interval`: replaced
`source.checked_sub(origin).ok_or_else(...)?` with plain `let time_diff = source - origin;`.
This reverses the fix's only implementation hunk exactly; the hunk applies directly to 55.2.0 (the surrounding
`compute_distance` checks added later for #22215 are left untouched).

## Oracle failure
`date_bin_errors.slt`: the new case (`i64::MAX` source, `i64::MIN` origin, 1ns stride) panics with
"attempt to subtract with overflow" instead of returning NULL.
