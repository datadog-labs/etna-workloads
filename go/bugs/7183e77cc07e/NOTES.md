Calls f(S{}) where the constraint C[E] has method m(<-chan E) but S has m(chan int).
Constraint method signatures must unify exactly during inference. The buggy compiler
unifies them inexactly, so E is inferred as int and the error comes later from the
satisfaction check ("S does not satisfy C[int]"). The clean compiler fails inference
("in call to f, T (type S) does not satisfy C[E]"). Both reject the program, but the
diagnostics differ.
