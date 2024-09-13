import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
export function firstThenLowerCase(strings, predicate) {
  const first = strings.find(predicate)
  return first?.toLowerCase()
}

// Write your powers generator here
export function powersGenerator({ofBase, upTo}) {
  return null
}

// Write your say function here
export function say(word) {
  return null
}

// Write your line count function here
export function meaningfulLineCount(filePath) {
  return null
}

// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d){
    Object.assign(this, {a, b, c, d})
  }
}
