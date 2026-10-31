Creates a Protocol subclass of collections.abc.Sized (after clearing Sized's ABC cache), then calls
isinstance(1, Sized). Clean prints False; buggy raises TypeError ("Instance and class checks can only
be used with @runtime_checkable protocols") because the runtime-protocol check moved into
_proto_hook, which ABCMeta calls for the non-protocol superclass.
