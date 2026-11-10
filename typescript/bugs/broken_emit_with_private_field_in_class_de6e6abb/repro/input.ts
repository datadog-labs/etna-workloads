declare let dec: any;

@dec((x: B) => x.#foo)
class B {
    #foo = 3;
}
