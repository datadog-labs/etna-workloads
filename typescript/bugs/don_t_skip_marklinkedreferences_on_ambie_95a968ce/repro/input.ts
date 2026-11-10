import { Observable } from './observable';

function whatever(a: any, b: any) {}

class Test {
    @whatever
    declare prop: Observable<string>;
}
