Input: a class extending `Observable<any>`, which has an overloaded `pipe` (11 overloads); the language service requests class-member snippet completions inside the derived class body.
The completion's insertText for `pipe` is generated via typeToTypeNode for the union return type of the overloads.
Clean passes NoTruncation, so the full union is printed; injected passes no flags, so the long union gets truncated (`...`) in the inserted text.
