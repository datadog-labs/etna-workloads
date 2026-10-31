from annotationlib import ForwardRef

TypeParamsAlias1 = int

class TypeParamsSample[TypeParamsAlias1, TypeParamsAlias2]:
    TypeParamsAlias2 = str

for is_class in (False, True):
    for name in ("TypeParamsAlias1", "TypeParamsAlias2"):
        r = ForwardRef(name, owner=TypeParamsSample, is_class=is_class).evaluate()
        print(is_class, name, r)
