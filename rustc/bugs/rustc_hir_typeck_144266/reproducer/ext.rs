#[macro_export]
macro_rules! eq {
    (assert $a:expr, $b:expr) => {
        match (&$a, &$b) {
            (left_val, right_val) => {
                if !(*left_val == *right_val) {
                    panic!("failed {:?} {:?}", left_val, right_val);
                }
            }
        }
    };
}
