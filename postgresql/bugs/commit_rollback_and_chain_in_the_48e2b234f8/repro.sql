START TRANSACTION ISOLATION LEVEL READ COMMITTED, READ WRITE, DEFERRABLE;
SAVEPOINT x;
COMMIT AND CHAIN;
SELECT current_setting('transaction_isolation') AS iso;
SELECT current_setting('transaction_deferrable') AS def;
COMMIT;
