input.ts imports "./a" (a.d.ts) under moduleResolution node10 with allowJs and --traceResolution.
Clean build looks up TypeScript/Declaration extensions first ("target file types: TypeScript, Declaration").
Injected build tries all extensions in one pass, so trace says "TypeScript, JavaScript, Declaration".
