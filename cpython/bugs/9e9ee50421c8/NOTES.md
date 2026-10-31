Reproducer: attaches a PropertyMock (already set on type(m)) to a Mock via attach_mock, then prints m.mock_calls.
Clean: `[]`. Buggy: __setattr__ no longer stores PropertyMock directly in __dict__, so the property is triggered and a call is recorded in mock_calls.
