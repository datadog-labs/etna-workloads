CREATE TABLE c (date date,time string,size int,rv string,ra string,ro string,package string,v string,country string,ip_id int);
COPY c FROM 'data/csv/real/tmp2013-06-15.csv.gz';
SELECT count(*) FROM c;
