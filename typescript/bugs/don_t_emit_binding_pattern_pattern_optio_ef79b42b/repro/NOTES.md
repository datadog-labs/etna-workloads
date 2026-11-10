Input declares `function g([x]?: number[] = [1]) {}`: an optional binding-pattern parameter that has an initializer, in an implementation.
Clean tsc does not report "A binding pattern parameter cannot be optional in an implementation signature" because an initializer is present.
Injected tsc reports that extra error (TS2463) since it ignores the initializer, so the diagnostics output differs.
