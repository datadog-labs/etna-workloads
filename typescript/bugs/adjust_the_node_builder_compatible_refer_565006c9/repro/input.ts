type Point = [number, number];
export function increment(point: Point) {
    return point.map(x => x + 1);
}
