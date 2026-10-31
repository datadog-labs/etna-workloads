Calls annotationlib.get_annotations(int) on a static builtin type. Clean returns {}; buggy lets the AttributeError from the type's __annotations__ descriptor escape.
