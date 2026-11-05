# Rationale

File: src/backend/commands/typecmds.c, function AlterTypeRecurse().

Traces to the fix.patch hunk that added the "Arrays inherit their base type's typmodin and typmodout" block. I removed that block. It is the code that looked up the type's typarray and recursed into it with the typmodin/typmodout parameters. Without it, ALTER TYPE ... SET (TYPMOD_IN/TYPMOD_OUT) updates only the base type (and domains), so the array type keeps the old typmodin/typmodout.

I left the isImplicitArray parameter in place. It is now always false, so it does nothing, and the other hunks of the fix are not needed to bring the bug back.

Failing oracle case: src/test/regress||create_type
