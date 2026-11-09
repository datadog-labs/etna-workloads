Changed tree/src/compiler/utilities.ts (both hunks of fix.diff):
- isRecognizedTripleSlashComment: removed the `fullTripleSlashAMDModuleRegEx` and `fullTripleSlashLibReferenceRegEx` checks, so `/// <amd-module>` and `/// <reference lib>` are no longer recognised as triple-slash directives. The import code fix then inserts imports above them (wrong ordering).
- Removed the two now-unused regex constants (as the fix added them), to keep the build clean.

SUMMARY: 5/25 oracle cases failing (1 fix-added).
