repro.sql runs generate_series(100,0,-10) with a value BETWEEN constraint (tabfunc01-1340, 1350).
Clean shell: 60 50 40, then no rows. Buggy shell: the descending-series bound adjustment in
seriesFilter uses the wrong comparison, so it returns an extra row (70 60 50 40, then a stray 40).
