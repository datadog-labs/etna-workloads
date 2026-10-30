# Rationale

Hunk reversed: fix's `save_loaded` flag + `resetServerSaveParams()` on the first "save" line in config.c.
In 9.0.7 this logic lives in `setConfigSaveOption` (src/config.c): when `reading_config_file` is set, the
first "save" line resets the default save params. I removed that else-branch, so config-file "save"
lines are appended on top of the defaults (3600 1 300 100 60 10000) instead of replacing them. This is
the #7092 regression the fix addressed. (No-"save" case still gives defaults, as before.)

Oracle: "CONFIG save params special case handled properly" (introspection.tcl) fails: with `save {100 100}`
override, `config get save` returns defaults plus `100 100` rather than `100 100`.
