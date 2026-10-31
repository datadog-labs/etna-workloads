Reproducer: exhausts a heap type's version-tag budget (forces tp_version_tag to 0), then runs an
instance property load (`instance.x`) in a loop until LOAD_ATTR tries to specialize.

Clean: prints `0` then `['LOAD_ATTR']` (specialization is refused, exit 0).
Buggy: the missing `tp_version == 0` check lets specialization proceed, so the debug build aborts with
`Assertion 'tp_version != 0' failed` in do_specialize_instance_load_attr (exit 134).
