A proc macro expands to a block using format!("{x}") with an implicit capture; the clean compiler accepts it and prints 5, while the injected one errors with 'there is no argument named x'.
