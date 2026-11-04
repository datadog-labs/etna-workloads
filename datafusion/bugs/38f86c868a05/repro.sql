select g1.value from generate_series(1, 3) g1 CROSS JOIN generate_series(1, 3) g2;
