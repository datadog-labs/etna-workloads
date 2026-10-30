Starts a server from a config file containing `save 100 100` and prints `CONFIG GET save`.
Clean: `100 100`. Buggy: the config-file save line is appended to the defaults (`3600 1 300 100 60 10000 100 100`)
because save params are no longer reset on the first `save` line when loading the file.
