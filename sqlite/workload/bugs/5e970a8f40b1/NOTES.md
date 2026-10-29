Renames a column used in an ORDER BY of a compound SELECT inside a trigger.
Clean shell rewrites the trigger (a -> abcd everywhere, exit 0). Buggy shell
fails the ALTER with "error in trigger r3 after rename: 1st ORDER BY term does
not match any column in the result set" (exit 1) and leaves the trigger unchanged.
