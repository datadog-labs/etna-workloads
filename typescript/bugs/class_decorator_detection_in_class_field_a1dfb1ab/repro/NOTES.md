input.ts is a class expression with decorated instance/static fields and static/instance `accessor`s, compiled with
`--target esnext --useDefineForClassFields false` (from issue #58436).
Clean: emits the transformed class JS (exit 0 printed, class code follows).
Injected: the class-fields transform treats the class expression as non-decorated and crashes with "Debug Failure" in getClassThis, so no output is emitted.
