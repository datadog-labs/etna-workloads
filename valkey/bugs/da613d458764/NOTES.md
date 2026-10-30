Runs a server with AOF enabled, issues HSETEX with lowercase `fnx`/`fxx` (and uppercase FNX) plus PXAT, then counts FNX/FXX tokens in the AOF.
Clean (strcasecmp) strips them from the propagated command: count 0. Buggy (strcmp) leaves lowercase `fnx` in the propagated command: count 1.
