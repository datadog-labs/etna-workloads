Reproducer: creates a file with mode 000, a TemporaryDirectory containing a symlink to it, sets the directory to 0o500 (so unlinking the symlink raises PermissionError), then calls cleanup().
Cleanup's permission-fixing must not follow the symlink. Clean prints target mode 0o0 (unchanged); buggy follows the symlink and chmods the target to 0o700.
