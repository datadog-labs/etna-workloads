repro.sql creates a table with an index on json_extract(j,'$.x'), then runs
json_array(+json_extract(...)) and json_array(++json_extract(...)) using that index.
Clean prints `[[1,2]]` for both; buggy loses the JSON subtype through the unary
"+" and prints `["[1,2]"]`.
