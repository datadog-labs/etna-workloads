Reproducer calls email header parser functions with an empty string. Clean raises HeaderParseError; buggy raises IndexError (value[0] on empty string).
