# gh-120868 reintroduced

Changed: `_is_queue_like_object` in Lib/logging/config.py (called from `configure_handler` for every `'queue'` config value that is not a str/dict).

Fix hunk reversed: the fix removed the unconditional `MM()` / `.Queue()` / `.JoinableQueue()` creation done for every QueueHandler `queue` config, and moved it so it only occurs for `BaseProxy` instances. In v3.15.2 that check was rewritten as a protocol check, so the eager Manager creation is restored at the top of the helper (before any isinstance check). Every queue-like object (and invalid ones) once again spawns a multiprocessing Manager, which can fail or hang depending on start method (the reported breakage).

Oracle cases failing (test_logging):
`test_config_queue_handler_does_not_create_multiprocessing_manager` and `test_config_queue_handler_invalid_config_does_not_create_multiprocessing_manager` (`manager.assert_not_called()` fails), plus other queue-handler config tests.
