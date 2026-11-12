SELECT COUNT(*) FROM read_parquet('data/parquet-testing/data-types.parquet', schema=map {'floatval': {name:'floatval', type:'DOUBLE', default_value:NULL}}) WHERE floatval = 4.6::DOUBLE;
