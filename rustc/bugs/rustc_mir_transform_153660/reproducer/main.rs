pub fn invalid_debuginfo() {
    foo();
}

pub fn foo() {
    bar(&1);
}

fn bar(x: &isize) {
    let a = 1;
    let mut z = x;
    z = &a;
}
