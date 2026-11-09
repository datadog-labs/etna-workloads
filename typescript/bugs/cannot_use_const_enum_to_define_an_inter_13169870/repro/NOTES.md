bar.ts uses an ambient const enum (declared in foo.d.ts) members as computed property keys in a type literal, under --isolatedModules.
Clean: no errors (type-only use site). Injected: reports error TS2748 "Cannot access ambient const enums when isolatedModules is enabled" for each key.
