class A { x: number = 1; }
class B extends A {
    declare x: number;
    constructor() {
        super();
        console.log(this.x);
    }
}
