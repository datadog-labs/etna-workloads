# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit b631d014987b9411ed0eeb7dcba9e0a8599bc3cf ("Fix pl/tcl's handling of errors from Tcl_ListObjGetElements()."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/pl/tcl/pltcl.c

Failing oracle cases:
- `src/pl/tcl||pltcl_call`
