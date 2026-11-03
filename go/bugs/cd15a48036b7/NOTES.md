repro.go is test/fixedbugs/issue8183.go made into a main package. It has const blocks whose errors come from an inherited init expression (iota).
Clean go reports the errors at the constant identifiers (repro.go:13:2, 19:2, 20:2).
Buggy go reports them at the inherited expression's position (10:12, 17:11, 17:11).
