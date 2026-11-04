SELECT overlay('abc' placing 'X' from 5 for 1);
SELECT overlay('abc' placing 'X' from 0 for 1);
SELECT overlay('abc' placing 'XY' from 2 for -1);
SELECT overlay('aébc' placing 'X' from 3 for 1);
SELECT overlay('αβγδ' placing 'XY' from 3 for 2);
SELECT overlay('abc' placing '' from 2 for 1);
