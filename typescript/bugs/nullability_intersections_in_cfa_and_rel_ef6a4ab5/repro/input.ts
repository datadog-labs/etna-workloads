function f3<T, K extends keyof T>(t: T[K], p1: Partial<T>[K] & {}, p2: Partial<T>[K] & ({} | null)) {
    t = p1;
    t = p2;
}
