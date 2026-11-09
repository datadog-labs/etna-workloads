Input: a derived class with a constructor containing a prologue directive ('inject') and `super()`, plus an ES-decorated method, compiled with target es2022.
Clean: constructor body is emitted once, with the injected initializers after super().
Injected: the constructor's statements are emitted twice (double-emit) because the body is visited and added before the initializer statements as well.
