class A {
    m(this: this) {}
}
class B extends A {
    n() { super.m(); }
}
class C<T extends A> {
    f(this: T) {}
}
class D extends C<A> {
    g() { super.f(); }
}
