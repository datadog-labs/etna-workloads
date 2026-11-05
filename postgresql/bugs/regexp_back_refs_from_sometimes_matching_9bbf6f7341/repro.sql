select 'abcdef' ~ '^(.)\1|\1.' as f;
select 'abadef' ~ '^((.)\2|..)\2' as f;
