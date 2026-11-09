class A {
    /**
     * Description text here.
     *
     * @virtual
     */
    foo() { }
}
class B extends A {
    override foo() { }
}
class C extends B {
    override foo() { }
}
