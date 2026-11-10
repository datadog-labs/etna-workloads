# Re-introduced bug: priority queue removeAt (nodejs/node 9ca5c525f4cd)

**Bug:** `PriorityQueue#removeAt(pos)` moved the last element into the hole and
then always sifted down from the root (`percolateDown(1)`) instead of from the
removed position, and never sifted up. When the moved element is smaller than
the parent at `pos`, the heap property is broken, and positions reported via
`setPosition` (used by timers) can be wrong.

## Hunk
`lib/internal/priority_queue.js`, `removeAt`: the fix's
`if (size > 0 && pos <= size) { percolateUp(pos) or percolateDown(pos) }` is
replaced with the old code: if `size > 0`, call `setPosition(heap[pos], pos)`
when `pos <= size`, then `percolateDown(1)`. This is the pre-fix behaviour,
re-expressed for the current private-field code. The fix's other hunk
(extracting `percolateUp`) is a refactor that is already in the tree and is
left alone, because `insert` still needs it.

## Failing test
`parallel/test-priority-queue` fails (stable over 2 runs):
`actual: 4, expected: 2` (`i3.position` after `removeAt(4)`; 3 should percolate
up).
