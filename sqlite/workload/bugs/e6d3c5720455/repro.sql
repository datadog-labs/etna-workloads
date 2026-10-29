SELECT quote(group_concat(x) OVER ()) FROM (SELECT '' AS x);
