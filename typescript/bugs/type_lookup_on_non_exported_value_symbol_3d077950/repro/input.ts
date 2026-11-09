declare function num(): number
const Unit = num()
export type Unit = number
const value = Unit

function Fn() {}
export type Fn = () => void
Fn()

const X = 1;
export interface X {}
