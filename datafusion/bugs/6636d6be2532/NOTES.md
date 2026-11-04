repro.sql writes four 1-partition-per-file parquet files, then runs a LEFT JOIN of the table against a
`DISTINCT ON` subquery with target_partitions=8 and repartition_file_scans=false.
df-clean returns the 12 expected rows. df-buggy fails planning with a SanityCheckPlan error
("does not satisfy distribution requirements: SinglePartition"), because the CollectLeft build-side
CoalescePartitionsExec is wrongly removed by sort parallelization. (The error text contains the run directory path.)
