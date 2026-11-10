class Foo {
    #x = 1;
    test(obj: Foo) {
        (obj.#x) = 2;
        ((obj.#x)) += 3;
    }
}
