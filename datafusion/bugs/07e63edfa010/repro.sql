SET datafusion.execution.target_partitions = 4;
SET datafusion.explain.format = indent;
CREATE TABLE string_topk(category varchar, val varchar) AS VALUES
('x', 'apple'),
('x', 'zebra'),
('y', 'banana'),
('y', 'apricot'),
('z', 'mango');
CREATE VIEW string_topk_view AS SELECT arrow_cast(category, 'Utf8View') AS category, arrow_cast(val, 'Utf8View') AS val FROM string_topk;
select category, max(val) from string_topk group by category order by max(val) desc nulls last limit 2;
explain select category, max(val) max_val from string_topk group by category order by max_val desc nulls last limit 2;
select category, max(val) from string_topk_view group by category order by max(val) desc nulls last limit 2;
explain select category, max(val) max_val from string_topk_view group by category order by max_val desc nulls last limit 2;
