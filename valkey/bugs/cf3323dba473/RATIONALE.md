# Rationale

## Changed: `rewriteConfigReadOldFile` in `tree/src/config.c`
Reverses the single fix hunk. The fix extended the "load as `# ???` comment"
condition so that lines starting with `include`, `rename-command`, `user`,
`loadmodule` and `sentinel` (config-file-only directives that `lookupConfig`
doesn't know) are kept. I restored the pre-fix condition
`argv == NULL || (!server.sentinel_mode && !lookupConfig(argv[0]))` and the
old comment. The code in 9.0.7 is otherwise the same, so this is equivalent
to the pre-fix code.

## Oracle failures
- `CONFIG REWRITE handles rename-command properly` (introspection.tcl) fails.
  After `CONFIG REWRITE` and a restart, the `rename-command` line was commented
  out, so `flushdb` works again (expected `ERR unknown command`, got `OK`).
- `ACL from config file and config rewrite` still passes. The `user` line is
  re-inserted at the end of the file rather than lost, so the ACL still loads
  after restart, which matches the upstream description (only messy comments).
