extern crate aux;
fn main() {
    let o = Some(aux::E::A);
    match o { None => (), Some(aux::E::A) => (), Some(aux::E::B) => () }
}
