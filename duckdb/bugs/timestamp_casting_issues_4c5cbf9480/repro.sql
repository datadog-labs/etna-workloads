.mode list
.nullvalue NULL
create table t (t timestamptz);
SET TimeZone='ECT';
SET CALENDAR='gregorian';
insert into t values('2028-02-28 01:00:00');
select t::timestamp = timestamp '2028-02-28 01:00:00' from t;
select timestamp '2028-02-28 01:00:00' = timestamp '2028-02-28 01:00:00', t = timestamp '2028-02-28 01:00:00' from t;
select count(*) from t where t::timestamp = timestamp '2028-02-28 01:00:00';
select * from t where t::timestamp = '2028-02-28 01:00:00';
select * from t where t = timestamp '2028-02-28 01:00:00';
select * from t where t::timestamp in (timestamp '2028-02-28 01:00:00',timestamp '2028-02-28 11:00:00');
create table u(t timestamp);
insert into u values('1993-02-28 01:00:00');
select t, t::timestamptz, '1993-04-28 01:00:00'::timestamptz, t::timestamptz='1993-02-28 01:00:00', t='1993-02-28 01:00:00' from u;
select '1993-03-28 02:00:00'::timestamp, '1993-03-28 02:00:00'::timestamp::timestamptz::timestamp;
create table t1 (ts_s TIMESTAMP_S, ts_ms TIMESTAMP_MS, ts_ns TIMESTAMP_NS, ts TIMESTAMP);
insert into t1 values ('2028-02-28 01:00:00.123456789', '2028-02-28 01:00:00.123456789', '2028-02-28 01:00:00.123456789', '2028-02-28 01:00:00.123456789');
select * from t1;
select ts = ts_s::TIMESTAMP, ts = ts_ms::TIMESTAMP, ts = ts_ns::TIMESTAMP from t1;
select ts::TIMESTAMP_S = ts_s, ts::TIMESTAMP_MS = ts_ms, ts::TIMESTAMP_NS = ts_ns from t1;
select ts_s::timestamp = timestamp '2028-02-28 01:00:00.123456789', ts_ms::timestamp = timestamp '2028-02-28 01:00:00.123456789', ts_ns::timestamp = timestamp '2028-02-28 01:00:00.123456789'  from t1;
