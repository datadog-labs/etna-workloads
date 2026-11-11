Using `#[cfg(version = "1.48.0")]` triggers an unexpected_cfgs warning; the clean compiler adds a suggestion to use `version("1.48.0")` predicate syntax, the injected compiler omits that help.
