Writes a ConfigParser (allow_unnamed_section=True) with an empty unnamed section plus
a named section, and prints the output. Clean: `'[section]\n\n'`. Buggy: the empty
unnamed section is written too (extra leading blank line / header-less output).
