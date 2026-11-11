macro_rules! m { ($a:lifetime) => { fn f<$a, 'a>() {} } }
m!('a);
fn main() {}
