Reproducer: `lazy import json` (a module with no dots, not yet loaded), then prints whether "json" is in `sys.lazy_modules`.
Clean: prints True. Buggy: prints False (simple lazy modules without submodules are not recorded).
