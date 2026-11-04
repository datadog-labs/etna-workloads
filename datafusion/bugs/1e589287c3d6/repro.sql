SELECT '22:00'::time + interval '3 hours';
SELECT arrow_typeof('01:00'::time + interval '3 hours');
SELECT '02:00'::time - interval '3 hours';
SELECT interval '3 hours' + '22:00'::time;
SELECT arrow_cast('22:00', 'Time32(Second)') + interval '3 hours';
