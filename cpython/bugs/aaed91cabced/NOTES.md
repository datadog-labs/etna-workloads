Reproducer for gh-125710: looking up an Enum member by an unhashable value (a `set`)
that equals a hashable member value (a `frozenset`).
Clean: `Directions({"sc"})` returns `<Directions.DOWN_ONLY: frozenset({'sc'})>`
Buggy: ValueError "is not a valid Directions" is raised (the `in` check prints True in both).
