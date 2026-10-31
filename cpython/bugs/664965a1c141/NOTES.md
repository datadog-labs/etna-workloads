Reproducer compiles a class whose method has a nested comprehension that rebinds a mangled
iteration variable (`__x`) via `:=`. Clean interpreter raises
"SyntaxError: assignment expression cannot rebind comprehension iteration variable '__x'";
the buggy one skips the check (name not mangled before symtable lookup) and prints "no error".
