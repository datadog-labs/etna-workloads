Defines a non-frozen and a frozen dataclass, then a `@dataclass(frozen=True)` child inheriting from both.
Clean: raises `TypeError: cannot inherit frozen dataclass from a non-frozen one`.
Buggy: the check uses "any base frozen" instead of "all bases frozen", so no error is raised ("no error").
