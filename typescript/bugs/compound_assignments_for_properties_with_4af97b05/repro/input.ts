class C {
    get x(): number { return 1; }
    set x(v: number | string) { }
}
const c = new C();
c.x += "a";
