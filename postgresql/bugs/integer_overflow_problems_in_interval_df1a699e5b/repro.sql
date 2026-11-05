select '9223372036854775807 us'::interval > '1 day'::interval as a;
select '2147483647 months'::interval > '1 month'::interval as b;
select '2147483647 days'::interval > '1 day'::interval as c;
select '1000000 years'::interval > '1 year'::interval as d;
