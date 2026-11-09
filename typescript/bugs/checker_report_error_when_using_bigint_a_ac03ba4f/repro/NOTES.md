input.ts declares an enum with a bigint-literal member name (`1n = 1`).
Clean tsc reports an error "An enum member cannot have a numeric name"; the injected build reports no such error (exit code/diagnostics differ).
