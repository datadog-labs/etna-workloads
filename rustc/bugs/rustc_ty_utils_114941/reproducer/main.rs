use std::any::{Any, TypeId};
pub fn call<T: ?Sized + 'static>(s: &T) -> TypeId { s.type_id() }
