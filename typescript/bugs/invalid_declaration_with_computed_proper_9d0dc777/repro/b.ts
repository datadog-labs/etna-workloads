import { a } from "./a";
export function fn({ [a]: value }: any): string {
    return value;
}
