Compiles `where F: FnOnce -> ()`; clean rustc emits the 'Fn bounds require arguments in parentheses' diagnostic, the injected one wrongly suggests moving the return type after the parameters.
