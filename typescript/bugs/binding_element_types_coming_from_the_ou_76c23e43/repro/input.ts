type NonEmptyStringArray = [string, ...Array<string>];
declare const strings: NonEmptyStringArray;
const [s0, s1] = strings;
s0.toUpperCase();
s1.toUpperCase();
