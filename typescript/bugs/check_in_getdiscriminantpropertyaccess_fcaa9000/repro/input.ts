type U = { type: 'A', aProp: number } | { type: 'B', bProp: string };
declare function isU(item: unknown): item is U;
declare const broken: Record<string, any> | undefined;
isU(broken) && broken.type === 'A' && broken.aProp;
