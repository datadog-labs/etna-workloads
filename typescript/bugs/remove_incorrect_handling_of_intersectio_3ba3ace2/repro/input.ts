type Path = string & { _pathBrand: any };
declare const lowercasePath: Lowercase<`foo/${Path}`>;
const x: number = lowercasePath;
