Builds a opposite-endian Structure, a opposite-endian Union containing it, and a Structure containing that union.
Clean: prints sizes `2 4`. Buggy: `_other_endian` rejects Union types, so a TypeError ("This type does not support other endian") is raised.
