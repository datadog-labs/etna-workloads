pub fn foo() {
    let x = 1;
    let _c = async move || { let _y = x; };
}
