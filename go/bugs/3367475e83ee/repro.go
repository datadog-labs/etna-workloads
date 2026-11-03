package main

type String string

func g[P any](P, string) {}

var f func(int, String) = g

func main() {}
