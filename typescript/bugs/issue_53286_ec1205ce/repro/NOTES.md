input.ts has a class whose property initializer reads a parameter property (`bar = this.foo`) compiled with target es2022 and useDefineForClassFields.
Clean: reports error TS2729 (used before its initialization). Injected: no error, since the check only applies for target ESNext.
