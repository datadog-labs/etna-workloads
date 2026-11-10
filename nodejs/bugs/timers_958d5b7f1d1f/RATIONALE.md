# Re-introduced bug: priority queue removeAt (nodejs/node#23870)

**Bug:** `PriorityQueue#removeAt(pos)` moves the last heap item into slot `pos` but does not re-heapify from `pos` or update the moved item's recorded position (via the setPosition callback). It percolates down from the root (`percolateDown(1)`) instead. Timers removed by position can then have stale positions, so later removals hit the wrong heap slot.

**Hunk (lib/internal/priority_queue.js, removeAt):** The fix added a setPosition call for the shifted item, guarded by `pos <= size`, inside `if (size > 0)`. Today's code instead has `if (size > 0 && pos <= size)` that percolates up or down from `pos`, and both percolate functions update positions. I replaced that block with the pre-fix `if (size > 0) this.percolateDown(1);`. The moved item is then neither repositioned nor reported through setPosition, which restores the old defect.

**Failing test:** parallel/test-priority-queue (failed on two runs). The new setPosition case fails: `assert.strictEqual(largest.position, 5)` reports `actual: 8, expected: 5`.
