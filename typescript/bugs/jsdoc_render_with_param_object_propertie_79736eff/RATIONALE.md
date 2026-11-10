# Rationale
Hunk: `tree/src/services/jsDoc.ts`, in `getJsDocTagsFromDeclarations`, removed the line
`infos.push(...getJSDocPropertyTagsInfo(tryGetJSDocPropertyTags(tag), checker));`.
This corresponds to the fix's only behavioural hunk, which added pushing of the nested property tags of a
name-first `@param {Object}` tag with a JSDocTypeLiteral. Today's code moved that logic into helpers (the helpers stay, unused by this path),
so removing the call restores the bug: `@param` Object sub-properties are no longer rendered as tags.
The import hunks need no counterpart because today's helpers still use those imports.

Final: SUMMARY: 1/1 oracle cases failing (1 fix-added).
