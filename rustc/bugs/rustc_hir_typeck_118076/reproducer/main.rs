use std::collections::HashSet;
#[derive(Debug, Eq, PartialEq, Hash)]
enum Day { Mon }
fn f(v: &HashSet<Day>) {
    let _x: HashSet<Day> = v.clone();
}
fn main() {}
