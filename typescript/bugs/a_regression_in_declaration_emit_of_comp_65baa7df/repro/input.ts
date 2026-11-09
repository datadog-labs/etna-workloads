declare function create<T extends {}>(): T;

export const c = create<{
  data: {
    ["a_b_c"]: string;
    s_d: string;
    ["foo bar"]: string;
  };
}>();
