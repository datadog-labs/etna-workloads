.mode list
.nullvalue NULL
PRAGMA explain_output = OPTIMIZED_ONLY;
SET TimeZone = 'UTC';
CREATE TABLE edge_tz(t TIMESTAMPTZ);
INSERT INTO edge_tz VALUES
  (make_timestamptz(-9223372036854775806)), ('2000-01-01'), (make_timestamptz(9223372036854775806)),
  ('-infinity'), ('infinity'), (NULL);
SELECT count(*) FROM edge_tz WHERE epoch(t) > -9223372036854775807;
SELECT count(*) FROM edge_tz WHERE epoch(t) < 9223372036854775807;
SELECT count(*) FROM edge_tz WHERE epoch_us(t) >= -9223372036854775806;
