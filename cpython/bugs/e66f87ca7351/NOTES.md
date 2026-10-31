Reproducer: a ForwardRef for `alias[int, undef]` is evaluated with Format.FORWARDREF and globals={"alias": dict}, where `undef` is undefined.
Clean: partially evaluates to `dict[int, ForwardRef('undef', ...)]`.
Buggy: globals are left out of the fake-globals dict, so `alias` is not found and the whole thing comes back as an unevaluated `ForwardRef('alias[int, undef]')`.
