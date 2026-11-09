# Rationale
One hunk: `tree/src/compiler/program.ts` (findSourceFileWorker), restored the `isReferencedFile(reason) &&` guard on the project-reference output redirect (`if (isReferencedFile(reason) && !useSourceOfProjectReferenceRedirect)`). This corresponds to the program.ts hunk of fix.diff. Without the fix, root files from a referenced project aren't redirected to their output .d.ts like imported ones are. The builder/tsbuildPublic hunks of the fix are supporting buildinfo changes and were left alone to keep the change minimal.

Final: SUMMARY: 6/93 oracle cases failing (4 fix-added).
