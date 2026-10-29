`repro.sh` starts the shell with `-pagecache 0 -1`, which makes pcache1 try a
1KB bulk allocation. It then sets `page_size=4096` on a file database and
creates a table. (`:memory:` does not trigger it.)

Clean: prints `exit=0`. Buggy: the bulk block is too small for one page, so
`pcache1InitBulk` computes nBulk=0 and the `do{}while(--nBulk)` loop runs
off the end of the allocation. The shell segfaults (exit 139 from the shell).
