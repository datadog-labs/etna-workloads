# gh-136421 reintroduced: _datetime static types initialized in module exec

The fix moved `_datetime`'s static-type initialization from the module exec
function (which can run concurrently in subinterpreters) to interpreter
startup. In v3.15.2 that is still the layout, so the change is reverted.

## Changes
- `Python/pylifecycle.c` (pycore_init_types): removes the `_PyDateTime_InitTypes()`
  call, reversing the fix hunk that added it.
- `Include/internal/pycore_pylifecycle.h`: removes the `_PyDateTime_InitTypes`
  declaration (reverses the header hunk).
- `Modules/_datetimemodule.c`: `_PyDateTime_InitTypes` becomes static
  `init_static_types` (the pre-fix name), and `_datetime_exec` calls it unless
  the module was loaded before in this interpreter (the pre-fix `reloading`
  check, derived from the INTERP_KEY entry in the interpreter dict). This reverses
  the hunk that turned `init_static_types(interp, reloading)` into
  `_PyDateTime_InitTypes`. The static-type init (and the min/max/resolution
  values) therefore run again inside the module exec, where concurrent
  subinterpreter imports race.

The tp_base and Setup.* hunks are left alone (they are not needed to restore the
race).

## Oracle
`ExtensionModuleTests.test_concurrent_initialization_subinterpreter` fails (crash
in concurrent static type init). The other 576 cases pass.
