Reproducer: selects from the eponymous generate_series in temp and an attached schema. Clean returns 1 2 3 4 for both; buggy reports 'no such table: temp.generate_series' / 'aux1.generate_series'.
