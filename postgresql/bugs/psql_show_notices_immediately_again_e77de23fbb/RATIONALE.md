# Rationale

All hunks are in src/bin/psql/common.c and reverse fix_impl.patch (which removed notice buffering).

- Added `struct t_notice_messages`, `AppendNoticeMessage`, `ShowNoticeMessage` (before SendQuery): the first hunk of the fix.
- `ExecQueryAndProcessResults`: re-added the `notices` local, the notice-processor interception before the first PQgetResult, `ShowNoticeMessage` before error display and before COPY handling, switching to the normal NoticeProcessor around HandleCopyResult, `notices.current ^= 1` around the look-ahead PQgetResult and after result handling, `ShowNoticeMessage` before printing the result, and the hook reset and buffer termination after the loop. These are the matching hunks of the fix.

Effect: notices are held until the result that follows them has been fetched, so they are not shown immediately. For example, a notice from a statement run via \watch or a long query appears late, or in a different order relative to the results.

Failing oracle case: src/test/regress||psql (see the oracle output).
