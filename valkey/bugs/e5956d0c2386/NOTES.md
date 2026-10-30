Enables `CLIENT TRACKING on BCAST` with 2000 distinct prefixes and compares the client's `tot-mem` (from `CLIENT INFO`) before and after. It prints whether the growth is under 120000 bytes.

The clean build estimates prefix overhead as `numnodes * (sizeof(raxNode) + sizeof(raxNode*))`, so the growth is about 83 KB. The buggy build uses `*` instead of `+`, so the growth is about 167 KB. The script prints "overhead ok" on clean and "overhead too large" on buggy.

The upstream test uses 10240 prefixes, but `valkey-cli` is very slow at feeding that many through stdin, so the script uses 2000.
