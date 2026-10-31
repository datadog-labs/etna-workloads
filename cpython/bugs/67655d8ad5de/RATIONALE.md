# Rationale

Fix gh-111615 let a QueueHandler be configured via dictConfig without `handlers`.
In v3.15.2 `Lib/logging/config.py` (`configure_handler`, QueueHandler branch), I reverted:

- The fix commented out `if 'handlers' not in config: raise ValueError('No handlers specified for a QueueHandler')`. I restored it. This is the pre-fix check.
- The fix wrapped the handler-resolution loop in `if 'handlers' in config:`. I removed the wrapper again, so the loop runs unconditionally, as before the fix.

The other hunks (`kwargs.get('handlers', [])` in `_configure_queue_handler`, and the MPQueue isinstance) are already covered differently in 3.15.2 (`kwargs.pop('handlers', [])`, `_is_queue_like_object`), so they were left alone.

## Oracle failures
`ConfigDictTest.test_111615` fails with `ValueError: No handlers specified for a QueueHandler`. Other ConfigDictTest cases that configure a QueueHandler without handlers (10 errors in total) fail the same way.
