Reproducer: repro.go is test/fixedbugs/issue50190.go. Two distinct struct types with embedded fields renamed via aliases (struct{Int} for different C aliases) must not compare equal as interface values.
Clean: exits 0. Buggy: the type symbols collide, so x == y and it panics "FAIL".
