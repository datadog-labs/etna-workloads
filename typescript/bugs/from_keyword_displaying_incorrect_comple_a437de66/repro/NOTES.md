Input: a JS file containing `import Foo ` (cursor after the space) followed by a function named `fromBar`; completions requested with import-statement completions enabled.
Clean: completions are just the `from` keyword (`["from"]`).
Injected: the `from` keyword handling for import-equals is missing, so the list differs (incorrect/extra completions such as globals).
