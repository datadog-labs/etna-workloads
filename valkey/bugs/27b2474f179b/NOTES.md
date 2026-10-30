Reproducer: sets a hash, then runs HGETEX/HSETEX with a key literally named "fields" plus HEXPIRE/HTTL.
Bug: fields_index starts at 0 instead of 2 in the HGETEX/HSETEX parsers, so the FIELDS keyword is
looked up from argv[0]. Clean: HSETEX on key "fields" returns 1. Buggy: "ERR value is not an integer
or out of range", and the following HTTL returns -2 (key never created).
