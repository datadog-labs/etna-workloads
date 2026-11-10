Input destructures `[file] = b` where `b` is narrowed to `never` (`declare const b: null`, else-branch of `b === null`), then reads the auto-typed `file`.
Clean tsc finishes normally (no crash). Injected tsc reports the not-iterable error with an undefined error node, so it crashes (stack trace in output).
