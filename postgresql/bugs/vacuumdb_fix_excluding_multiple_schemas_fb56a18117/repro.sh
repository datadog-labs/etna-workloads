psql -X -q -c 'create schema "Foo"; create table "Foo".bar(id int); create schema "Bar"; create table "Bar".baz(id int);'
vacuumdb -e -N "\"Foo\"" -N "\"Bar\"" postgres 2>&1 | grep -E '^VACUUM' | grep -E 'Foo|Bar'
echo done
