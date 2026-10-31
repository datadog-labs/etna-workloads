Calls GNUTranslations.ngettext with a float (1.0) and prints where the DeprecationWarning
points. Clean: the caller's line (repro.py:9). Buggy: stacklevel is hardcoded to 4, which
lands inside gettext.py (gettext.py:449) instead of user code.
