#![feature(gen_blocks, async_iterator)]
use std::async_iter::AsyncIterator;

fn moved() -> impl AsyncIterator<Item = u32> {
    let mut x = "foo".to_string();

    async gen {
        x.clear();
        for x in 3..6 { yield x }
    }
}

fn main() { let _ = moved(); }
