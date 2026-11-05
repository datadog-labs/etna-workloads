# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit d685e2424967509f004d9eb6d005dfb58e21d837 ("Fix descriptor output in ECPG."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/interfaces/ecpg/preproc/type.c

Failing oracle cases:
- `src/interfaces/ecpg||compat_informix/describe`
- `src/interfaces/ecpg||sql/desc`
- `src/interfaces/ecpg||sql/describe`
- `src/interfaces/ecpg||sql/dynalloc`
- `src/interfaces/ecpg||sql/dynalloc2`
- `src/interfaces/ecpg||sql/dyntest`
