pub async fn f() {}
pub fn g() { let _c = async || { f().await }; }
