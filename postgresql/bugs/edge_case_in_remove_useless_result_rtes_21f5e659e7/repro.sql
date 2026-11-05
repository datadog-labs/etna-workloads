select * from (values (1),(2)) v(x)
  left join (select q from (select 7 as q from (select where false) ss1) ss2
             left join (select 8 as z) ss3 on true) ss4 on true;
