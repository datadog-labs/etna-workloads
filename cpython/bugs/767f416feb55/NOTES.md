Reproducer round-trips a scoped IPv6Address via copy, deepcopy and pickle. Clean keeps scope_id ('scope'); buggy drops it (None), so equality is False.
