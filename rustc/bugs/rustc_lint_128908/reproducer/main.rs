#![deny(explicit_outlives_requirements)]
pub trait TypeCx { type Ty; }
pub struct Pat<Cx: TypeCx> { pub ty: Cx::Ty }
pub struct Rec<'thir, 'tcx: 'thir> {
    pub pat: Pat<Rec<'thir, 'tcx>>,
}
impl<'thir, 'tcx: 'thir> TypeCx for Rec<'thir, 'tcx> { type Ty = (); }
fn main() {}
