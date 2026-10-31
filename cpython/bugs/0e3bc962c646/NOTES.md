Reproducer drives pyrepl's ReadlineAlikeReader (FakeConsole, ModuleCompleter + rlcompleter) with
"import pri<TAB>", "from pri<TAB>", "from typong import Na<TAB>".
Clean: the module completer's (empty) result is final, so the input is unchanged.
Buggy: an empty module completion falls through to the regular rlcompleter, yielding
'import print(' / 'from print(' / 'from typong import NameError('.
