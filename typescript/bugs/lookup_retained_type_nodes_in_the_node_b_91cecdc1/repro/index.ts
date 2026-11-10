import * as E from 'whatever';

export const run = <E>(i: () => E.Whatever<E>): E.Whatever<E> => E.something(i);
