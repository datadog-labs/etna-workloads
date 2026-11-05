select to_char(1.2e-1005::numeric, '9.99EEEE');
select to_char(1.2e-2000::numeric, '9.99EEEE');
select to_char(1.2e1005::numeric, '9.99EEEE');
