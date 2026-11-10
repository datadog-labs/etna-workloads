type _ERef<T> = T | Promise<T>;
import { ParamStateRecord as _ParamStateRecord } from './types.js';
declare global {
  // @ts-ignore TS2666
  export {
    _ERef as ERef,
    _ParamStateRecord as ParamStateRecord,
  };
}
