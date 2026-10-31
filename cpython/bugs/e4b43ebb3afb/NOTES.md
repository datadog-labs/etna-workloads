Mock(spec=class with an async method), then seal(). Accessing the async method on the sealed mock should raise AttributeError.
The buggy build checks _spec_asyncs before the sealed check in _get_child_mock, so it returns an AsyncMock instead of raising.
