Input is the upstream noCrashOnMixin2 case: a class extends a mixin call result, and a method does `new Concrete()` where Concrete has a protected constructor via a base class.
Clean: reports normal diagnostics (incl. TS2674), exit 2.
Injected: tsc crashes with an uncaught exception in isConstructorAccessible (getBaseTypes on a non-class type), exit 1, no diagnostics.
