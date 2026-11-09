function f<T extends any[], P extends any[]>(x: any[]): [...T, ...P] {
  return x;
}
