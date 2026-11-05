SELECT width_bucket('Infinity'::numeric, 1, 10, 10),
       width_bucket('-Infinity'::numeric, 1, 10, 10);
SELECT width_bucket(2.0, 3.0, '-inf', 888);
