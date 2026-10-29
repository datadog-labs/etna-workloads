# Rationale

Fix: unixFullPathname resolved a relative symlink target against the link's
directory and followed nested links (the fix added the readlink loop and prefixed
`zIn`'s directory to relative targets). Pre-fix, a relative readlink result was
interpreted relative to the cwd.

v3.54.1 has no readlink loop; `appendOnePathElement` (src/os_unix.c) handles links.
Change: for a relative link target it used to drop the link name
(`nUsed -= nName+1`, so the target resolves against the link's directory). Now it
resets the path to the cwd and appends the target, i.e. resolves relative to cwd
as the pre-fix code did. Absolute targets are unchanged.

Oracle failures: symlink-4.2.1/4.2.2, 4.3.1/4.3.2, 4.4.1/4.4.2 (links in
subdirectories with relative targets: "unable to open database file" / wal file
created at wrong location).
