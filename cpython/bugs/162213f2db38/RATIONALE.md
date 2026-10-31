# gh-108791 reintroduced in Lib/pdb.py

v3.15.2 moved the logic into `_ScriptTarget._check` and `_ModuleTarget.__init__`.

1. Fix hunk `_ScriptTarget.check`: added `os.path.isdir` -> "is a directory" exit.
   Reversed by removing the equivalent `os.path.isdir(target)` block in `_ScriptTarget._check`.
   A directory passed as the script is no longer rejected up front.
2. Fix hunk `_ModuleTarget.check`: added `except ImportError as e: print(f"ImportError: {e}"); sys.exit(1)`
   before the generic handler. Reversed by removing that clause in `_ModuleTarget.__init__`,
   so ImportError falls to `except Exception` and prints a full traceback.
   (`_ZipTarget` has the same clause but was not part of the fix, so it is untouched.)

Oracle failures (test_pdb: 5 failures, 1 error): test_dir_as_script, test_nonexistent_module,
test_module_without_a_main, test_package_without_a_main (expected concise message not in stdout; a traceback goes to stderr instead), plus others sharing the same paths.
