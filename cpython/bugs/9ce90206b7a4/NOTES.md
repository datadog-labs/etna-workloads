Calls tomllib.loads() with bytes and bool. Clean: TypeError "Expected str object, not 'bytes'/'bool'".
Buggy: TypeError with bytes' native replace() message, and AttributeError for bool.
