Reproducer for gh-101892: a two-arg iter() callable that exhausts its own iterator re-entrantly, then returns a non-sentinel value.
Clean: next() raises StopIteration. Buggy: SystemError / assertion failure instead.
