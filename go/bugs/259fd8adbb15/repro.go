package main

const MaxInt512 = (1<<256 - 1) * (1<<256 + 1)
const _ = MaxInt512 ^ -1
const _ = ^MaxInt512

func main() {}
