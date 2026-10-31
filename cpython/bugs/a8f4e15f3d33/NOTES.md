Reproducer: forces sys.is_finalizing() True and closes a loop with a signal handler. Clean emits ResourceWarning 'skipping signal handlers removal'; buggy raises NameError (typo 'warinigs').
