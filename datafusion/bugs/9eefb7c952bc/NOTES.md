Reproducer: median() over a sliding RANGE window (1 PRECEDING to CURRENT ROW) on VALUES (1.0),(1.0),(2.0),(5.0).
Clean build returns medians 1,1,1,5. The buggy build's MedianAccumulator::retract_batch skips the swapped-in element after swap_remove, so it fails with "Internal error: median retract_batch: retracted value(s) not present in the window."
