trait Kind {
    fn kind();
}

impl<T> Kind for Option<T> {
    fn kind() {}
}

fn main() {
    let _value = Some(2_i32);
    _value.kind();
}
