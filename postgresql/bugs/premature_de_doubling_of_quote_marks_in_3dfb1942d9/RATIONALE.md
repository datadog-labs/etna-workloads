# Rationale

File: src/interfaces/ecpg/preproc/pgc.l (lexer rules), reverting all three fix_impl.patch hunks:

1. `<xq,xe,xn,xus>{xqdouble}`: now `addlitchar('\'')` instead of `addlit(yytext, yyleng)`. This de-doubles '' prematurely in the preprocessor, so the C output string loses the doubled quote.
2. `<xqc>{xqcquote}`: now adds `\` and `'` separately instead of `addlit(yytext, yyleng)` (premature rewriting of the quote).
3. `<xd,xui>{xddouble}`: now `addlitchar('"')` instead of `addlit(yytext, yyleng)`, de-doubling "" in identifiers.

Failing oracle cases:
- src/interfaces/ecpg||preproc/strings
- src/interfaces/ecpg||sql/dyntest
