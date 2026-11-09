Input: `type Test = \`T\`;` with find-references requested inside the template literal (a NoSubstitutionTemplateLiteral under a LiteralType).
Clean: findReferences returns normally (prints a result). Injected: Debug.assert in tryGetImportFromModuleSpecifier throws, so the script prints "crash".
