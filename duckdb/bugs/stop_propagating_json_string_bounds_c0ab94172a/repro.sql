.mode list
.nullvalue NULL
SET debug_verify_stats=true;
CREATE TABLE js(j JSON);
INSERT INTO js VALUES ('{"bbbb":12345678,"aaaa":1}'), ('{"bbbb":87654321,"aaaa":2}');
SELECT j::VARIANT::JSON FROM js;
