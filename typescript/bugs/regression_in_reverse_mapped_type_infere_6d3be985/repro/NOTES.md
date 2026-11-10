Input is the redux-style `configureStore({reducer: {counter1: counterReducer1}})` case: inference of S through a homomorphic reverse mapped type (ReducersMapObject), after an earlier call inferred from a plain `reducer`.
Clean: compiles with no errors. Injected: the reverse-mapped cache is shared between the two caches, so S is inferred as unknown and TS2322 is reported on `counter1`.
