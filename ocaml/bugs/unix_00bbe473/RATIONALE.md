# Rationale
Hunk: ocaml/otherlibs/unix/unix.ml, `find_proc_id` now removes the entry from `popen_processes` after finding it (inside the mutex).
Reverses fix.diff hunk `@@ -1108,12 +1108,13 @@ let open_process_full cmd =` (otherlibs/unix/unix.ml), which made find_proc_id only look up and added remove_proc_id. The later `remove_proc_id` calls in close_process_* remain (now no-ops), as in the old code's effective behaviour.
Effect: process_*_pid drops the process from the table, so the following close_process_* raises EBADF.
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/lib-unix/common/process_pid fails (Unix_error EBADF process_pid).
