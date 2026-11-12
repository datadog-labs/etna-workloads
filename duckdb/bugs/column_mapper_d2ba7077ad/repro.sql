CREATE VIEW m AS SELECT * FROM read_parquet('data/parquet-testing/complex.parquet', schema=map {
 'mainProduct': {name:'mainProduct', type:'STRUCT(parts STRUCT(parts STRUCT(quantity BIGINT, extra INTEGER))[])', default_value: NULL,
  children: map {'parts': {name:'parts', type:'STRUCT(parts STRUCT(quantity BIGINT, extra INTEGER))[]', default_value: NULL,
   children: map {'list': {name:'element', type:'STRUCT(parts STRUCT(quantity BIGINT, extra INTEGER))', default_value: NULL,
    children: map {'parts': {name:'parts', type:'STRUCT(quantity BIGINT, extra INTEGER)', default_value: NULL,
     children: map {
      'quantity': {name:'quantity', type:'BIGINT', default_value: NULL},
      'extra': {name:'extra', type:'INTEGER', default_value: '7'}}}}}}}}}});
SELECT mainProduct.parts FROM m;
