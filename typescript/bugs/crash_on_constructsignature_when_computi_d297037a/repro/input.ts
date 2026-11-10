interface DivElement {}
declare var DivElementCtor: {
  prototype: DivElement;
  new(): DivElement;
};
interface ElementMap {
  div: typeof DivElementCtor;
}
declare function getCtor<K extends keyof ElementMap>(tagName: K): ElementMap[K] | undefined;
const div = getCtor("div");
