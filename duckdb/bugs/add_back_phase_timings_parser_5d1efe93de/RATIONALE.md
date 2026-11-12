# Rationale

Today's code already has a refactored form of the fix (AddParserTime takes a Profiler + timestamps), so the
original hunks don't map 1:1. I undid the last hunk of the fix, in `src/main/statement_iterator.cpp`
(`StatementIterator::GetStatementInternal`): removed the `profiler.StartQuery(statement->query, ...)` call
made right after the statement is fetched. Without it the profiler is not running when
`AddParserTime` is called, which returns early (`!running`). So parser time is dropped and the query SQL
isn't recorded for statements obtained via the iterator (including EXPLAIN ANALYZE without global profiling).
`StatementIteratorIsExplainAnalyze` is marked `[[maybe_unused]]` only to keep the build warning-free.

Oracle results: see etna-check output (filled in below if available).

## etna-check output
FAIL cpp:test/api/test_query_profiler.cpp::Test parser timing is reported per statement
     test_query_profiler.cpp:99 :: output.find("\"parser\"") != std::string::npos  (npos != npos)
1 of 6 oracle units fail. The other five pass (they pass on the current tree; only the parser-timing test exercises this path).
