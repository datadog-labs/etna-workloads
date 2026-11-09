type Tuple<T> = readonly [T, ...T[]];
interface Target { onclick: (e: number) => void; onkeydown: (e: string) => void; }
declare function bindAll<
  TTarget extends Target,
  TTypes extends Tuple<keyof TTarget>
>(
  target: TTarget,
  bindings: {
    [K in keyof TTypes]: {
      type: TTypes[K];
      listener: (ev: Parameters<Extract<TTarget[TTypes[K]], (...args: any[]) => any>>[0]) => void;
    };
  }
): void;
