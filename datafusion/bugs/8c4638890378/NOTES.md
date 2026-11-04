`repro.sql` calls `array_distance` on nested (multidimensional) arrays, using the statements from the fix's `array_length.slt` tests.

- **Clean build:** each query fails with the planning error "array_distance only supports one-dimensional arrays".
- **Buggy build:** the nested-array check is missing, so each query succeeds. It computes the distance from only the first inner array, for example `2.0` for `[[1,2],[100,100]]` vs `[[1,4],[0,0]]`.
