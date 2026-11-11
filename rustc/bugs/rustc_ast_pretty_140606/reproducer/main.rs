fn main() {
    let x = 1;
    let _t = match x {
        _ => {
            'a: loop {
                println!("a long enough line to force wrapping of the printed output, yes");
                println!("another long enough line to force wrapping of the printed output");
                break 'a;
            }
        }
    };
}
