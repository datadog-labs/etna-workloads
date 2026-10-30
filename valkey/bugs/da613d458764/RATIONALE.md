# Rationale

The fix is titled "replace strcmp with strcasecmp". Valkey 9.0.7 already
contains the argv-rewrite code the fix added, so reversing the hunks does not
apply. The case-sensitivity defect (#2996) can still be restored in that code.

## Change (src/t_hash.c, hsetexCommand)

In the loop that builds `new_argv` for propagation, the filter that skips the
FNX/FXX flags used `strcasecmp`. It now uses `strcmp`.

This reverses the case-insensitive comparison that the fix introduced, as the
commit message describes. The command parser accepts FNX/FXX in any case, but
the propagation filter only strips the exact uppercase spelling. So a command
sent with lowercase `fnx` or `fxx` is propagated to replicas and the AOF with
that flag still in it. The validation argument is therefore replicated.

## Oracle failure

`tests/unit/hashexpire.tcl`: "HSETEX is not replicating validation arguments"
fails. The replication stream contains `hsetex myhash2 fnx PXAT ...` and
`hsetex myhash2 fxx PXAT ...`, where `hsetex myhash2 PXAT ...` is expected.
The uppercase cases still pass. It is the only one of the 408 oracle cases
that fails.
