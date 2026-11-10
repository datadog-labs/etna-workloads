Calls languageService.getDocCommentTemplateAtPosition on `function f(a: number, b: string) {}` with formatOptions `newLineCharacter: "\r\n"`.
Clean build uses the passed newline in the template (`\r\n`); the injected build ignores formatOptions and uses the host default (`\n`).
