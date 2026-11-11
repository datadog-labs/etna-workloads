Calling a `&mut self` method on the item of `for test in &tests` yields E0596. The clean compiler also suggests "use a mutable iterator instead" (`&mut tests`); the injected compiler omits that help.
