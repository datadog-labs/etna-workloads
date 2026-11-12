SET threads=1;
CREATE TABLE clustered AS SELECT (i // 64)::INTEGER AS i FROM range(4099) r(i);
SELECT (stats(i)).approx_unique BETWEEN 32 AND 130 FROM clustered LIMIT 1;
