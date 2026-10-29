`repro.sh` builds a 1024-byte-page db with a 4-row t1 (root = page 2, interior), then overwrites the root's right-child pointer (offset 1032) with page 1 and runs `DELETE FROM t1`.

Clean shell: "database disk image is malformed" (exit 1), and integrity_check reports problems.
Buggy shell: `freePage2: Assertion 'iPage>1' failed` (abort, exit 134), because freePage2 no longer rejects page 1.
