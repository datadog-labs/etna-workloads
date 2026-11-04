SET datafusion.explain.analyze_level = dev;
SET datafusion.explain.analyze_categories = 'bytes';
SET datafusion.execution.target_partitions = 2;
SET datafusion.optimizer.repartition_joins = true;
SET datafusion.optimizer.prefer_hash_join = false;
CREATE TABLE ea_smj_t1(a text, b int) AS VALUES ('Alice', 50), ('Alice', 100), ('Bob', 1);
CREATE TABLE ea_smj_t2(a text, b int) AS VALUES ('Alice', 2), ('Alice', 1);
EXPLAIN ANALYZE
SELECT ea_smj_t1.a, ea_smj_t1.b, ea_smj_t2.a, ea_smj_t2.b
FROM ea_smj_t1
JOIN ea_smj_t2 ON ea_smj_t1.a = ea_smj_t2.a
    AND ea_smj_t2.b * 50 <= ea_smj_t1.b;
