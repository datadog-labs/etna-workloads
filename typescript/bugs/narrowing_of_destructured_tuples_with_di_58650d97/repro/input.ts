function fz1([x, y]: [1, 2] | [3, 4] | [5]) {
    if (y === 2) {
        x;
    }
    if (x === 1) {
        y;
    }
    if (x === 5) {
        y;
    }
}
