declare const Symbol: (s: string) => symbol;
const mySymbol = Symbol("test");
interface TestInterface {
    [mySymbol]: string;
    normalProperty: number;
}
const obj: TestInterface = {} as any;
obj.
