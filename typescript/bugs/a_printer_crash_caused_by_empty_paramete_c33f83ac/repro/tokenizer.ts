export default abstract class Tokenizer {
  errorBuilder() {
    return (pos: number, lineStart: number, curLine: number) => {};
  }
}
