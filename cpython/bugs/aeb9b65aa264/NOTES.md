Blocks only SIGTERM in the caller, starts a ResourceTracker, and prints the caller's signal mask afterwards.
Clean: `['SIGTERM']` (mask restored). Buggy: `[]` (SIG_UNBLOCK also unblocks SIGTERM, which the caller had blocked).
