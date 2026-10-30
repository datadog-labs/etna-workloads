Sets hash-max-listpack-value 8, then uses HINCRBYFLOAT to create a value (>8 chars) and a field (>8 chars) in a new hash.
Clean: both hashes are converted to `hashtable`. Buggy: hashTypeSet no longer converts on oversize field/value, so they stay `listpack`.
