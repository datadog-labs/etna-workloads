type Z = 'z'
const e = {
  e: 'e'
} satisfies {
    [index in Z]: string
  }
