repro.sh builds two packages a and b that each return `struct{ _ []int }{}` as interface{}, and a main that compares the values (issue 47087).
Clean toolchain: prints `false false`.
Buggy toolchain: with blank unqualified in the type link string, the two distinct types collide, so the compiler fails with an internal compiler error ("collision: types struct { _ []int } and ... have link string"), exit 1.
