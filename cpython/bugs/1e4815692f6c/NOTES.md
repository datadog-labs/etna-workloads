Calls `create_autospec(X, spec_set=True, name="Y")` and prints `mock._mock_name`.
Clean: prints `'Y'`. Buggy: `name` is popped too late, so it is passed on to
`configure_mock`, which raises `AttributeError: Mock object has no attribute 'name'`.
