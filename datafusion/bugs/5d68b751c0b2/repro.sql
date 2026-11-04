select trunc(3.76, 1) a, trunc(arrow_cast(3.76,'Float32'),1) b, trunc(-2.99::double, 1) c;
select trunc(v, 1) from (values (0.837::double),(1.96::double)) t(v) order by 1;
