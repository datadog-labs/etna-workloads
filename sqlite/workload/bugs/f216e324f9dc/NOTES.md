repro.sh builds a 512-byte-page table, then overwrites the cell count of page 2 (offset 515) with 0x0054 (84),
which is more than the page can hold. It then does two inserts into the corrupted leaf.
Clean shell: the inserts reach the corruption check and report "database disk image is malformed".
Buggy shell: the insert aborts on the assert in insertCell (`pPage->nCell<=MX_CELL(...)`), because the
injection removed the `|| CORRUPT_DB` exemption from that assert.
