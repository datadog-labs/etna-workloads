Blocks SIGINT in the caller, starts a ResourceTracker, and prints the caller's signal mask afterwards.
Clean: the mask is restored, prints ['SIGINT'].
Buggy: the tracker unblocks SIGINT with SIG_UNBLOCK instead of restoring the previous mask, so the mask is empty ([]).
