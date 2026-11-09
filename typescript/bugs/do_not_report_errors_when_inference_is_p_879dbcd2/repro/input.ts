declare function func<T extends { foo: 1 }>(arg: T): void;
func({ foo: 1, bar: 1 });
