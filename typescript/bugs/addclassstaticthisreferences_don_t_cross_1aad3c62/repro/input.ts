class C {
    static s() {
        this;
    }
    static get f() {
        return this;
        class Inner { x = this; }
    }
}
