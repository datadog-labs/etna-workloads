#![crate_type = "staticlib"]
#[no_mangle]
pub static CACHED_POW10: [(u64, i16, i16); 4] = [
    (0xe61acf033d1a45df, -1087, -308),
    (0xab70fe17c79ac6ca, -1060, -300),
    (0xff77b1fcbebcdc4f, -1034, -292),
    (0xbe5691ef416bd60c, -1007, -284),
];
