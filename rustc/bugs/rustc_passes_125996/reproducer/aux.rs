pub static K: fn() -> fn() = {
    #[inline(never)]
    fn k() {}
    #[inline(always)]
    || -> fn() { k }
};
