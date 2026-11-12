FROM query('SELECT typeof(1' || repeat('0', 274) || '), (1' || repeat('0', 274) || ') = 1e274');
