Defines a TypedDict `Base` and subclass `Child` in a `from __future__ import annotations` module, then prints `Child.__annotations__` and `get_type_hints(Child)`.
Clean: both include the inherited `base` and `child` (as ForwardRefs and as int, respectively).
Buggy: the stringified-annotation path (`ns["__annotations__"]` kept in the namespace) drops inherited keys, so only `child` appears.
