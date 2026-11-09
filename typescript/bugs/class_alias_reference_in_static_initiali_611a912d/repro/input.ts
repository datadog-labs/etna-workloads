declare var dec: any;
@dec
class C {
    static x = C.name;
    static y = () => C;
}
