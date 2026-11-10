class A implements A {
  get x(): string { return "" }
}
const e = new A()
e.x
