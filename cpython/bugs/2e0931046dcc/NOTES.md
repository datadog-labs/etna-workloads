Mock(spec=obj) must not evaluate properties on obj; buggy getattr(spec, attr) calls the property (prints 'property called', _instance set).
