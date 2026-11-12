.mode list
.nullvalue NULL
SELECT finalize(to_aggregate_state([ {'v0' : 1} ], 'string_agg', [ 'VARCHAR', 'VARCHAR' ], NULL,[ {'column' : 0, 'order' : 'ASC NULLS FIRST'} ]));
