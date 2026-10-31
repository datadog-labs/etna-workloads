repro.py checks that unittest.mock respects `wraps` for return values: `Mock(spec=Order, wraps=Order)` child `return_value`, calling a wrapped child, and `create_autospec(f, wraps=f)()`.
Clean: prints `sentinel.DEFAULT`, `'third'`, `'real'`.
Buggy: return_value is auto-created as a child Mock, so the wrapped object is ignored and calls return Mock objects.
