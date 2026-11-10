Input: a class expression `(class C2 { static staticProp = 10; [C2.staticProp]() {} })` that uses itself in its own computed property name.
Clean: tsc reports TS2449 "Class 'C2' used before its declaration" and exits 2.
Injected: no diagnostic is reported and the exit status is 0.
