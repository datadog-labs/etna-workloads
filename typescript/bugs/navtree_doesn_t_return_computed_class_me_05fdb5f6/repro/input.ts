const key = "a";
class C {
    [key]() {}
    ["lit"]: number = 1;
    [1]() {}
    [Symbol.iterator]() {}
}
