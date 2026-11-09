Uses tsserver's ProjectService with a small plugin that makes `x.ts` TS first, then TSX. Project A parses it as TS (the cached sourceFile on the ScriptInfo), then releases it while another project keeps the ScriptInfo alive.
A new project D then acquires `x.ts` as TSX with identical text.
Clean: the cached TS sourceFile is rejected (scriptKind mismatch) and x.ts is reparsed as TSX, so D reports only the JSX IntrinsicElements error.
Injected: the stale cached TS sourceFile is reused, so D reports "'>' expected" and "Cannot find name 'div'".
