function f<T extends unknown[]>(t: [string, ...T, number]) {
    const b = t[1];
    let [c1, c2] = t;
}
