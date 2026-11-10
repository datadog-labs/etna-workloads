declare const o: { [k: string]: number };
declare const k: string;
o[k] += 1;
o[k]++;
o.a += 1;
o.a++;
const r: number = (o[k] += 1);
