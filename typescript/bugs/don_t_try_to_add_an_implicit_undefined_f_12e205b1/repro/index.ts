import { createApi } from "./createApi";

const slice = createApi({
  endpoints: {
    test: {
      url: `/user`,
    },
  },
});

export const { useTestQuery } = slice;
