Spawns a child with gc.DEBUG_STATS, gc.collect(), checks stderr for the 'gc: done, ... elapsed' line. Clean prints True; buggy prints False (line missing).
