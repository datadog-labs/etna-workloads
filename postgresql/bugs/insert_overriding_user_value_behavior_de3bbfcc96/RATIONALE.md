# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit de3bbfcc962f24c1a20a17b76c604e5973a05817 ("Fix INSERT OVERRIDING USER VALUE behavior"), applied to REL_18_6 (with fuzz). It restores the code the fix replaced.

Files: src/backend/rewrite/rewriteHandler.c

Failing oracle cases:
- `src/test/regress||identity`
