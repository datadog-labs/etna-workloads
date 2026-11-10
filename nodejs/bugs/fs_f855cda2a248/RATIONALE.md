# Rationale

**Bug:** `fs.cpSync` error "Cannot overwrite non-directory %s with directory %s" had its two path arguments swapped: source dir was reported as the non-directory and dest file as the directory.

**Hunk:** `src/node_file.cc`, `CpSyncCheckPaths` (the THROW_ERR_FS_CP_DIR_TO_NON_DIR call, now around line 4581). The fix swapped args to `dest_path_str, src_path_str`; the release has the same code (without `message.c_str()`), so I reverted it to `src_path_str, dest_path_str`.

**Failing test:** `parallel/test-fs-cp-sync-copy-directory-to-file-error` (failed on both runs). Message: `Cannot overwrite non-directory .../FIRST_DIRECTORY with directory .../README.md`, which doesn't match `/non-directory .*README\.md with directory .*FIRST_DIRECTORY/`.
