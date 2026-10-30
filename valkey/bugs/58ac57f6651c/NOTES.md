repro.sh sets foo to "1" (via SETRANGE) and runs INCRBYFLOAT. Clean: 'ERR value is not a valid float'. Buggy: the string-to-double check stops at the NUL byte and the command succeeds, returning 2.
