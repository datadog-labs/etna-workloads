Meta (with annotations, __future__) as metaclass; Base has none. get_annotations(Base) should be {} but the buggy build returns the metaclass's annotations via getattr.
