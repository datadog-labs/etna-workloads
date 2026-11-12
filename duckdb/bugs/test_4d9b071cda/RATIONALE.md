# Rationale
Hunk: src/function/table/direct_file_reader.cpp, DirectFileReader::Scan (FILE_CONTENT_COLUMN).
Traces to the fix's direct_file_reader.cpp hunk (`read_until_eof = is_pipe || file_size == 0`). Today's code had
`file_handle->IsPipe() || file_size == 0` (with a comment); I removed the `file_size == 0` fallback so that
zero-sized special files (procfs) are no longer read until EOF and yield empty content, as before the fix.
The pipe_file_system.cpp hunk (throwing in GetFileSize) is not reverted: it is a hardening change, not needed for the bug.

Oracle:
FAIL     test/sql/table_function/issue_25882.test
         Mismatch on row 1, column (length("content") > 0)(index 2): 0 <> true
1 of 1 oracle units fail
