Reproducer: builds a LiveStatsCollector with a MockDisplay, sends 'h' (opens help) then 'q'
through `_handle_input()`, and prints `show_help` and `running`.

Clean: pressing 'q' on the help screen only closes help (`running: True`).
Buggy: the missing early `return`s let 'q' fall through to the quit handler (`running: False`).
