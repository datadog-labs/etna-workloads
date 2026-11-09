Input declares an empty `interface HTMLMissingElement {}` and accesses `.textContent` on it, compiled with `--lib es5,dom`.
Clean: error TS2339 "Property 'textContent' does not exist on type 'HTMLMissingElement'".
Injected: TS2812 "...Try changing the 'lib' compiler option to include 'dom'" (the check compares against "dom" instead of "lib.dom.d.ts").
