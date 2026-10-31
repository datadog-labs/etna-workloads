Calls `io.TextIOBase.read.__get__(io.StringIO(), "not_a_type")`, a METH_METHOD
descriptor given a non-type as arg 2. Clean prints the proper TypeError message
("descriptor 'read' needs a type, not 'str', as arg 2"). The buggy build passes
a wrong format-argument list (missing `%s` arg), giving garbage output or a crash.
