const a = '1';
const b = a + ' 2';
const d = `${b} 3` as const;
const e: "1 2 3" = d;
