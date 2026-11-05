create function plpgsql_arr_domain_check(val int[]) returns boolean as $$
begin return val[1] > 0; end
$$ language plpgsql immutable;
create domain plpgsql_arr_domain as int[] check(plpgsql_arr_domain_check(value));
do $$
declare v_test plpgsql_arr_domain;
begin
  v_test := array[1];
  v_test := v_test || 2;
  raise notice 'ok %', v_test;
end;
$$;
