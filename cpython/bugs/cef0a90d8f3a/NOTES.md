Defines a Structure with a `c_char * sys.maxsize` field and prints the field's byte/bit size.
Clean: prints `9223372036854775807 73786976294838206456`.
Buggy: struct/union size is read with a C int, so class creation raises OverflowError.
