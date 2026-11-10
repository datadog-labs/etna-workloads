Input: a.tsx (non-JSX exports) and b.ts in an in-memory language service; calls getMoveToRefactoringFileSuggestions on a.tsx for the first statement.
Clean: the suggested target files include /b.ts (ts files allowed when moving non-JSX content from tsx).
Injected: only .tsx files are suggested, so /b.ts is missing.
