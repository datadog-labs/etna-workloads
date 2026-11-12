# Rationale

## Hunk: src/storage/statistics/string_stats.cpp, `StringStats::MergeStats`
Traces to the single hunk of the fix. I removed the block added by the fix: the `!is_min && memcmp(prefix equal)` special case, which kept a truncated prefix as the max bound when merging against a longer exact string. Without it, `new_is_more_extreme` is just `comparison > 0` for max. A truncated 12-byte max prefix 'abcdefghijkl' therefore loses to the longer 'abcdefghijklA', so the stats claim max = 'abcdefghijklA' even though the real value is 'abcdefghijklzzzz'. The optimizer then wrongly folds the `> 'abcdefghijklB'` comparison to false.

## Oracle result
```
FAIL     test/sql/optimizer/string_stats_merge_truncated_prefix.test
         Wrong result in query! (test/sql/optimizer/string_stats_merge_truncated_prefix.test:8)!
         SELECT (CASE WHEN c THEN s ELSE 'abcdefghijklA' END) > 'abcdefghijklB' FROM t;
         Expected result: true   Actual result: 0
1 of 1 oracle units fail
```
