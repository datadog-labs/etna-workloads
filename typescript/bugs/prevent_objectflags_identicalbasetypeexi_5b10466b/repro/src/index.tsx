
import React from 'react'

declare function upperFirst<T extends string>(str: T): Capitalize<T>

const displayEnum = (value: string) => upperFirst(value.toLowerCase())

function Comp() {
  return <div>
    <span>Scope:</span> {displayEnum("VALUE")}
  </div>
}
