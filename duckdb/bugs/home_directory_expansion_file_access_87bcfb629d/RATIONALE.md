# Rationale

## Hunk: src/src/common/opener_file_system.cpp, OpenerFileSystem::VerifyCanAccessFileInternal
Traces to the fix's single hunk, which canonicalized the path (expanding `~` via the connection opener)
before `config.CanAccessFile`. In today's code the opener is passed to `CanAccessFile(path, type, opener)`,
which expands `~` with the connection's home_directory. I changed it to `config.CanAccessFile(path, type)`,
so the opener defaults to nullptr and `~` expands to the process home. The access check then uses a
different home than the file open does, which is the original bug.

## Oracle
```
FAIL     test/sql/settings/allowed_directories_home_directory.test
         test/sql/settings/allowed_directories_home_directory.test:21
         Query unexpectedly succeeded! (test/sql/settings/allowed_directories_home_directory.test:21)!
1 of 1 oracle units fail
```
