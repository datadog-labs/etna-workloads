Creates a database, patches the schema file format header byte (offset 47) down to 1, runs
ALTER TABLE ADD COLUMN, then prints that byte.
Clean shell: 3 (upgrades to at least 3 but not to 4). Buggy shell: 4 (always upgrades to 4,
which can corrupt pre-existing DESC indexes).
