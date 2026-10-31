Builds a colored parser (FORCE_COLOR=1) with a mutually exclusive group containing a nargs='*' positional and prints repr(format_usage()).
Clean: outer [] of the positional is stripped before color codes are added -> "badger ..." inside the group.
Buggy: color codes are prepended first, so the part[0]=='[' check fails and the usage shows "[badger ...]" nested in the group.
