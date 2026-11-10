#[non_exhaustive]
enum E { A(String, String) }
fn main() {
    let x = E::A("a".to_string(), "b".to_string());
    let c = || {
        match x {
            E::A(a, _) => drop(a),
        }
    };
    c();
}
