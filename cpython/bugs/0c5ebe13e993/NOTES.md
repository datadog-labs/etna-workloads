repro.py loads `_testsinglephase_check_cache_first` (from _testsinglephase) via ExtensionFileLoader.
Its init calls PyState_FindModule() before the module def has an index (m_index == 0).
Clean: prints the module name. Buggy: aborts with `Assertion 'index > 0' failed` in
_get_module_index_from_def (Python/import.c).
