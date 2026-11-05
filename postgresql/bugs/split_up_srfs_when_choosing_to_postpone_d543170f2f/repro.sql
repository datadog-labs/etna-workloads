create function zero() returns int language plpgsql volatile as 'begin return 0; end';
select generate_series(0,2) as s1, generate_series(zero(),2) as s2
order by s2 desc;
