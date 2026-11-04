Reproducer: runs `array_slice`, `array_pop_front` and `array_pop_back` over `List(non-null Int32)` and `LargeList(non-null Int32)` inputs, including empty and NULL rows. It also prints `arrow_typeof` of the results.

Clean build: the queries return the rows, and the result type keeps `non-null Int32`.

Buggy build: the slice builder rebuilds the output list with a nullable field. The result type no longer matches the type promised at planning time. Both queries fail with "Internal error: Assertion failed: result_data_type == *expected_type ...".

The Spark `slice` case from the fix is not included. `slice` is not registered in datafusion-cli, so the statement errors on both builds.
