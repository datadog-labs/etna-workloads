.mode list
.nullvalue NULL
SET debug_verify_serializer = true;
SELECT map_contains(MAP {'Apple': 1}, 'apple' COLLATE NOCASE),
       contains(MAP {'Apple': 1}, 'apple' COLLATE NOCASE),
       map_contains(map(['Apple' COLLATE NOCASE], [1]), 'apple'),
       map_contains(MAP {'Apple': 1}, 'banana' COLLATE NOCASE),
       map_contains(map([['Apple' COLLATE NOCASE]], [1]), ['apple']),
       map_contains(map([array_value('Apple' COLLATE NOCASE)], [1]), array_value('apple')),
       map_contains(NULL::MAP(VARCHAR, INTEGER), 'apple' COLLATE NOCASE);
