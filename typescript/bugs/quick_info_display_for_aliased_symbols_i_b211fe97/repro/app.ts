import { someEnv } from "./modules";
declare function isString(v: any): v is string;

if (isString(someEnv)) {
  someEnv.charAt(0);
}
