Reproducer for join-25.1: a view column `(NULL AND 5)` used in the ON clause of a LEFT JOIN.
Flattening substitutes the AND expression, but with the bug only its root is marked as coming
from the ON clause. The clean shell prints 1; the buggy shell gives a different count (see check.sh).
