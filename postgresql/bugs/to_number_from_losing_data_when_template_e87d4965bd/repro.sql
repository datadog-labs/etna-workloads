SET lc_numeric = 'C';
SELECT to_number('1234', '9,999');
SELECT to_number('123456','999G999');
SELECT to_number('42nd', '99th');
