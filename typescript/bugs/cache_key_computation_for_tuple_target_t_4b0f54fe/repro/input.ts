interface MultiKeyMap<Keys extends readonly unknown[], Value> {
  get<Key extends GetKeys<Keys>>(...key: Key): GetResult<Keys, Key, Value>;
}
type GetKeys<Keys extends readonly unknown[]> = Keys extends [...infer Remain, infer _]
  ? Keys | GetKeys<Remain>
  : Keys;
type GetResult<Id extends readonly unknown[], Args extends GetKeys<Id>, Value> = Args extends Id
  ? Value | undefined
  : Id extends [...Args, ...infer Rest]
  ? Iterable<[...Rest, Value]>
  : never;
declare const x: MultiKeyMap<[id1: string, id2: string], object>;
declare const id1: string;
export const matches: number = x.get(id1);
