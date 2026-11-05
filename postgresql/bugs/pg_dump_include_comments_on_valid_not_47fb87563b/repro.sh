psql -X -q -c "create table nn(a int constraint nn_a_nn not null)" -c "comment on constraint nn_a_nn on nn is 'hello nn'"
pg_dump -s | grep -i -E "hello|nn_a_nn"
