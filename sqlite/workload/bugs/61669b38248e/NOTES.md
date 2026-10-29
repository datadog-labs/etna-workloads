Adds the string '9223372036854775807' (INT64 max) to 0 in both operand orders.
Clean shell prints 9223372036854775807 for both; the buggy shell converts the
string to a float, so it prints 9.2233720368547758e+18 (loses integer precision).
