# Re-introduced bug (CVE-2026-48617)

`process.report.writeReport()` did not validate `fs.write` permission in JS against the
resolved target (file or `process.cwd()`), so the permission check relied only on the C++
check in `src/node_report.cc`, which sees the unresolved/generated relative filename and is
therefore unaware of the cwd (e.g. after `process.chdir`).

## Change
`lib/internal/process/report.js`: removed the `if (permission.isEnabled()) {...}` block in
`writeReport` (and the now-unused `ERR_ACCESS_DENIED`, `sep`, `permission` imports). This
corresponds to the fix's single implementation hunk adding the permission check (the release
had a variant that prefixed `report.directory`; the whole check is removed to restore the
pre-fix behaviour).

## Failing test
`parallel/test-permission-fs-write-report`: the denied-error `resource` is
`report.<date>...json` instead of `process.cwd()`:
`+ resource: 'report.2026....json'  - resource: '<node-checkout>'`
