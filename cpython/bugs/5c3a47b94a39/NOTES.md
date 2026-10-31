Reproducer: os.pathconf(-1, 'PC_NAME_MAX'). Clean treats -1 as an fd (OSError EBADF); the buggy build checks fd != -1, so it calls pathconf() with a NULL path.
