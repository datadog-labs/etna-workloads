Reproducer: `SELECT typeof(group_concat(x)) FROM (SELECT '' AS x);`
Clean shell prints `text` (empty string); buggy shell prints `null`, because group_concat() skips appending an empty first value so the accumulator is never created (ticket 55746f9e65f8587).
