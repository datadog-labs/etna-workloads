Passing an empty block `{}` where a `Box<()>` is expected: the clean compiler emits a help suggestion to wrap it in `Box::new(())`; the injected compiler omits that suggestion.
