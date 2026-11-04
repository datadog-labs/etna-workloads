SET datafusion.execution.target_partitions = 4;

CREATE TABLE issue_22895_rt2 AS SELECT * FROM (VALUES
  (named_struct('msg','user auth failed','sid','a'), 1, 'svc1'),
  (named_struct('msg','login token','sid','b'), 2, 'svc2')
) v(attributes, id, name);

SELECT a.id, b.name
FROM issue_22895_rt2 a JOIN issue_22895_rt2 b
  ON a.attributes['sid'] = b.attributes['sid']
WHERE a.attributes['msg'] LIKE '%auth%'
ORDER BY a.id, b.name;

CREATE TABLE issue_22895_rt AS SELECT * FROM (VALUES
  (named_struct('uid','u1','t','t1'), TIMESTAMP '2026-06-08T10:00:00', 'a'),
  (named_struct('uid','u2','t','t2'), TIMESTAMP '2026-06-08T11:00:00', 'b')
) v(attributes, start_timestamp, span_name);

SELECT r.start_timestamp
FROM issue_22895_rt r
JOIN (SELECT attributes['uid'] AS uid FROM issue_22895_rt) f
  ON f.uid = r.attributes['uid']
WHERE r.attributes['t'] IN (SELECT attributes['t'] FROM issue_22895_rt)
ORDER BY r.start_timestamp;
