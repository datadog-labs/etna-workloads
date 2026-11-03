repro.go: declares `var _ io.Writer = W{}` where W embeds `*bufio.Writer` (bufio not imported, so the embedded field type is invalid).
Clean compiler reports only the "undefined" errors. The buggy compiler also reports a follow-on error:
`W does not implement io.Writer (missing method Write)` at 5:19, since hasAllMethods' invalid-embedded-field check was removed.
