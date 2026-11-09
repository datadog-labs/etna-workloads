Input: `const fn = () =>\n    async () => { };` run through the language service refactor "Convert to named function".
Clean output is `function fn() {\n    return async () => { };\n}`; the injected build loses the text range on the synthesized
return statement, so the output for the concise async body is wrong (differs from clean).
