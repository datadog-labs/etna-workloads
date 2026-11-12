select 1 as one, max(5) as m group by one having max(date '1000-01-01') <= current_date;
