Parses known args with a subparser into a class used as the namespace (gh-116850).
Clean: returns (C, ['-p']) with C.w == 7. Buggy: the subparser action calls
vars(namespace).setdefault(...) on a class's mappingproxy, raising AttributeError/TypeError.
