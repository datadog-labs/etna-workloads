Builds ast.FunctionDef without the optional `returns` field and calls copy.replace(node, name="bar").
Clean: succeeds, prints `bar None []`. Buggy: raises TypeError because the optional/defaulted fields (returns, decorator_list) are treated as required.
