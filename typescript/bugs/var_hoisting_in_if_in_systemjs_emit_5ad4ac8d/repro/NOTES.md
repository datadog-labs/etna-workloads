Input: an ES module with `var` declarations inside both branches of a top-level `if`/`else`, compiled with `--module system`.
Clean: the `var`s are hoisted to `var x, y;` in the System.register wrapper and the branches become plain assignments.
Injected: the `if` statement is not visited, so the `var`s stay as declarations inside the branches and are not hoisted.
