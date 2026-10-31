Zero-argument `super()` inside a `@dataclass(slots=True)` method. The clean build
fixes the `__class__` closure cell to point at the new slotted class, so it prints
`True`. The buggy build leaves it pointing at the original class and raises
`TypeError: super(type, obj): obj must be an instance or subtype of type`.
