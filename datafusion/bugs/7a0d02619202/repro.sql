CREATE TABLE struct_and_list_table
AS VALUES
    (struct(1, 2), [10, 20, 30]),
    (struct(3, 4), [40, 50]);

SELECT sum(get_field(s, 'c0'))
FROM (SELECT s, unnest(arr)
      FROM (SELECT column1 AS s, column2 AS arr
            FROM struct_and_list_table));

CREATE TABLE list_struct_table
AS VALUES
    ([struct(1, 'a'), struct(2, 'b')]),
    ([struct(3, 'c')]);

SELECT get_field(unnest(column1), 'c0'), get_field(unnest(column1), 'c1')
FROM list_struct_table;
