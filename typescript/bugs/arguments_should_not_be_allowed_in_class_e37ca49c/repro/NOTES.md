Input uses `arguments` directly inside a class static block of a class returned from a function.
Clean: error TS2815 "'arguments' cannot be referenced in property initializers or class static initialization blocks."
Injected: the message is the old "'arguments' cannot be referenced in property initializers." (static-block wording lost; the check also differs for arrows/static blocks).
