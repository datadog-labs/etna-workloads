Mock(spec=Foo) where Foo has methods named `assert_bar`/`assertSome`. Clean: accessing them works
and prints "ok". Buggy: the spec exemption is removed, so access raises AttributeError
("... is not a valid assertion. Use a spec for the mock").
