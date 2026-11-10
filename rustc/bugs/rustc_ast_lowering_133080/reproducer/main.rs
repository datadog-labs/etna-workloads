mac::macro_rpit!{}

fn main() {
    let mut x = vec![1];
    let element = test_mbe(&x);
    x.push(2);
    println!("{element}");
}
