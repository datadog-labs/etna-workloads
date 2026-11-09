const sym = Symbol();
class B { [sym]() {} }
class D extends B { override [sym]() {} }
class E extends B { override [Symbol.iterator]() {} }
