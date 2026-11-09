const k = "a";
class A {
  a = 1;
  [k] = 2;
}
class B extends A {
  override [k] = 3;
}
