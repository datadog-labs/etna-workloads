Creates a venv in a directory named `"';&&$e|'"`, sources its bash `activate`, and echoes `$VIRTUAL_ENV`.
Clean: `<cwd>/"';&&$e|'"` (template values are shlex-quoted). Buggy: `<cwd>/';&&|'` (unquoted substitution, so the shell mangles the name).
