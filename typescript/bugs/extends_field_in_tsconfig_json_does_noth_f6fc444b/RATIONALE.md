# Rationale
Hunks in tree/src/compiler/commandLineParser.ts (fix's diagnosticMessages.json hunk left as-is: message is just unused):
1. `parseOwnConfigOfJson` equivalent (now ~line 3511): `json.extends || json.extends === ""` -> `json.extends`. Matches fix hunk 1; empty-string extends is again silently ignored.
2. `getExtendsConfigPath`: removed the `extendedConfig === ""` branch emitting "Compiler option 'extends' cannot be given an empty string"; always emits File_0_not_found. Matches fix hunk 3.

Final: SUMMARY: 4/14 oracle cases failing (0 fix-added).
