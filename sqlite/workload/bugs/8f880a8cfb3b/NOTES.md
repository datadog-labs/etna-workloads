repro.sh builds a 1024-byte-page DB whose CREATE TABLE text (~950 chars) is too large for
page 1, so page 1 becomes an interior page with no cells and a single child. It then zeroes
the right-child pointer (bytes 108-111) and runs `SELECT * FROM sqlite_master`.

Clean shell: "database disk image is malformed" (exit 1).
Buggy shell: `moveToRoot: Assertion 'subpage>0' failed`, abort (exit 134).

Covers corrupt-5.2; the other failing cases (6.1, 8.1, 8.2) were not separately reproduced.
