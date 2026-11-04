SET datafusion.execution.target_partitions = 4;
COPY (SELECT column1 AS c_custkey, column2 AS c_phone, arrow_cast(column3, 'Decimal128(15, 2)') AS c_acctbal
      FROM (VALUES (1::BIGINT, '13-a', 10.0), (2::BIGINT, '17-b', 20.0), (3::BIGINT, '18-c', 30.0),
                   (4::BIGINT, '23-d', 5.0), (5::BIGINT, '29-e', 40.0)))
TO 'customer.parquet';
COPY (SELECT column1 AS o_custkey FROM (VALUES (1::BIGINT), (4::BIGINT))) TO 'orders.parquet';
CREATE EXTERNAL TABLE sq_count_customer STORED AS PARQUET LOCATION 'customer.parquet';
CREATE EXTERNAL TABLE sq_count_orders STORED AS PARQUET LOCATION 'orders.parquet';
select count(*) from (
    select cntrycode, count(*) as numcust, sum(c_acctbal) as totacctbal
    from (
        select substring(c_phone from 1 for 2) as cntrycode, c_acctbal
        from sq_count_customer
        where c_acctbal > (select avg(c_acctbal) from sq_count_customer where c_acctbal > 0.00)
          and not exists (select * from sq_count_orders where o_custkey = c_custkey)
    ) as custsale
    group by cntrycode
) as q;
