//@[full]    compile-flags: -Cdebuginfo=full
trait Fun {
    const FUN: &'static fn();
}
impl Fun for () {
    const FUN: &'static fn() = &(detail::f as fn());
}
mod detail {
    // Place `f` in a distinct module to generate a separate code generation unit.
    #[inline(never)]
    pub(super) fn f() {}
}
fn main() {
    // SingleUseConsts represents "x" using VarDebugInfoContents::Const.
    // It is the only reference to `f` remaining.
    let x = <() as Fun>::FUN;
}
