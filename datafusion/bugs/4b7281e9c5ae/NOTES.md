repro.sql calls abs() with string arguments (three forms, from math.slt).
Clean build: planning error "Function 'abs' expects Numeric but received String ...".
Buggy build: get_valid_types no longer rejects non-numeric types for TypeSignature::Numeric, so the query gets past planning and fails with "This feature is not implemented: Unsupported data type Utf8 for function abs".
