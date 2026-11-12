CREATE TABLE integers AS SELECT i k, i j FROM range(5) t(i);
SELECT k FROM integers where j::VARCHAR SIMILAR TO '[0-9]*';
