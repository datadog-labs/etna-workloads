Reproducer (repro.sql): a trigger body contains a CTE named `map` and also references `main.map`.
Clean shell: `main.map` resolves to the real table (`main1`/`main2`).
Buggy shell: without `notCte`, the schema qualifier stripped from the trigger by FixTriggerStep
lets `main.map` match the CTE, so main_map shows `cte1`/`cte2`.
