Configures a QueueHandler via dictConfig with a `queue` but no `handlers` key.
Clean: succeeds, prints `QueueHandler`. Buggy: raises ValueError
("No handlers specified for a QueueHandler"), since the injection makes `handlers` mandatory.
