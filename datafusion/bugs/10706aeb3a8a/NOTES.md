`repro.sql` calls `MAP` in its variadic form (`MAP('type','test')`, `MAP('a',2,'b',3)`) and with one array argument.

- df-clean: the variadic calls plan through `make_map` and return `{type: test}` and `{a: 2, b: 3}`. The one-argument call fails with "make_map requires an even number of arguments".
- df-buggy: the `map` name is no longer routed to `plan_make_map`. The first two queries fail with "Expected list, large_list or fixed_size_list, got Utf8" and "map function requires 2 arguments, got 4". The third fails with "map function requires 2 arguments, got 1".

The exit status is 0 on both builds. Only the output differs.
