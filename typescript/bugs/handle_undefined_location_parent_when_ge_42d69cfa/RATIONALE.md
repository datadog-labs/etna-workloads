# Rationale
Single hunk in tree/src/services/symbolDisplay.ts (~line 497): removed the `location.parent &&` guard before `isConstTypeReference(location.parent)`, mirroring the sole hunk of fix.diff. With an undefined `location.parent` during getCompletionEntryDetails, this throws "Cannot read properties of undefined (reading 'kind')".

Final check.sh: SUMMARY: 1/1 oracle cases failing (1 fix-added).
