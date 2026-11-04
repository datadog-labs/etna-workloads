repro.sql calls range/generate_series with step 0 and with a non-integer 2nd argument (`range(1, 'bar')`).
Clean: "Step cannot be zero" and "Argument #2 must be an INTEGER or NULL, got ...".
Buggy: "step cannot be zero" and "First argument must be an integer literal".
