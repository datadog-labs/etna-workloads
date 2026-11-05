# Verbatim injection

This injection is the reverse of the implementation hunks of upstream commit bde7493d10898831100a0c6c233a5f3030bfcecd ("Fix overflow check and comment in GIN posting list encoding."), applied to REL_18_6 (exactly). It restores the code the fix replaced.

Files: src/backend/access/gin/ginpostinglist.c

Failing oracle cases:
- `src/test/modules/test_ginpostinglist||test_ginpostinglist`
