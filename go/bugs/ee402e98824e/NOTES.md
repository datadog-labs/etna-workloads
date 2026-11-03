repro.go passes func(chan int) / func(<-chan int) arguments to generic functions whose parameters have the opposite channel direction.
Clean toolchain: inference fails with "type ... does not match ... (cannot infer T)", because element types are unified exactly.
Buggy toolchain (assign mode no longer implies exact for element types): channel direction is ignored during inference, so the error is instead the later "cannot use ... as ... value in argument" message.
