.mode list
.nullvalue NULL
SET threads=1;
SELECT remap_struct(struct_pack(id := id, m := MAP {1: 'a', 2: 'b'}),
                    NULL::STRUCT(id INTEGER, m2 MAP(INTEGER, VARCHAR)),
                    {'id': 'id', 'm2': ROW('m', {'key': 'key', 'value': 'value'})},
                    NULL)
FROM range(3) t(id);
