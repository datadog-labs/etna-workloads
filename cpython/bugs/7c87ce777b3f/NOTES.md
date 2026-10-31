Traces a function whose code has co_filename "<unknown>" (no source) using trace.Trace(trace=1).
Clean: each traced line prints "<unknown>(N)" followed by a newline.
Buggy: prints "<unknown>(N): " with no newline, so the entries run together on one line.
