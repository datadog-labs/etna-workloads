Reproducer: repro.sql runs zipfile() on a truncated zip image (test zipfile-20.0).
Clean shell: "Runtime error: zip archive is corrupt". Buggy shell: the generic "database disk image is malformed" error (no specific message set for the corrupt CDS).
