import { Foo } from "./a";
const Decorator: ClassDecorator = () => undefined;
@Decorator
class Bar {
    constructor(par: Foo) {}
}
