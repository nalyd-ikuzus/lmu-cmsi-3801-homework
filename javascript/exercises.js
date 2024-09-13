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
  const first = strings.find(predicate) //Find the first string that satisfies the predicate and then return the lower case version
  return first?.toLowerCase()
}

// Write your powers generator here
export function* powersGenerator(powersArgs) {
  let currentNum = 1
  const {ofBase, upTo} = powersArgs
  while(currentNum <= upTo){ //While the current number is less than the limit, keep yielding the number and multiplying by the base
    yield currentNum
    currentNum *= ofBase
  }
}

// Write your say function here
export function say(word) {
  if (word == undefined){ //Check base case
    return ""
  }
  else{ //Otherwise return function to concatenate the strings
    return (nextWord) => {
      if(nextWord == undefined){
        return word
      }
      else {
        return say(word + " " + nextWord)
      }
    }
  }
}

// Write your line count function here
export async function meaningfulLineCount(filePath) {
  let meaningfulLines = 0
  const file = await open(filePath, "r") //Open the file
  for await (const line of file.readLines()) { //For each line in the file, filter for whitespace and check to see if it has meaning
    const filteredLine = line.replace(/\s+/g, "")
    if(filteredLine != "" && !filteredLine.startsWith("#")){
      meaningfulLines += 1
    }
  }
  return meaningfulLines
}

// Write your Quaternion class here
export class Quaternion {
  constructor(a, b, c, d){
    Object.assign(this, {a, b, c, d})
    Object.freeze(this)
  }
  get conjugate(){
    return new Quaternion(this.a, -this.b, -this.c, -this.d)
  }
  get coefficients(){
    return [this.a, this.b, this.c, this.d]
  }
  plus(other) {
    return new Quaternion(this.a + other.a, this.b + other.b, this.c + other.c, this.d + other.d)
  }
  times(other) {
    return new Quaternion(
      ((this.a * other.a) - (this.b * other.b) - (this.c * other.c) - (this.d * other.d)), 
      ((this.a * other.b) + (this.b * other.a) + (this.c * other.d) - (this.d * other.c)), 
      ((this.a * other.c) - (this.b * other.d) + (this.c * other.a) + (this.d * other.b)), 
      ((this.a * other.d) + (this.b * other.c) - (this.c * other.b) + (this.d * other.a))
      )
  }
  equals(other){
    return this.a == other.a && this.b == other.b && this.c == other.c && this.d == other.d
  }
  toString() {
    let strRepresentation = ""
        const myCoefficients = this.coefficients 
        console.log("Starting string conversion")
        console.log(myCoefficients)
        for (let i = 0; i < myCoefficients.length; i++){
          console.log(myCoefficients[i])
          if(myCoefficients[i] != 0){
            if (strRepresentation != "" && myCoefficients[i] > 0){ //Add an addition sign if there's something before the current value and the value is positive
              strRepresentation += "+"
              console.log("Adding addition sign")
            }
            else if(myCoefficients[i] < 0){ //Add a negative/subtraction sign if the value is negative
              strRepresentation += "-"
              console.log("Adding negative sign")
            }
            if ((myCoefficients[i] != 1 && myCoefficients[i] != -1) || i == 0){ //We don't want to print +-1 unless it's the first value, which doesn't have a variable attached
              strRepresentation += Math.abs(myCoefficients[i]).toString()
              console.log("Adding value")
            }
            switch (i){ //Add variables
              case 1:
                strRepresentation += "i"
                console.log("Adding i")
                break
              case 2:
                strRepresentation += "j"
                console.log("Adding j")
                break
              case 3: 
                strRepresentation += "k"
                console.log("Adding k")
                break
              default:
                {}
            }
          }
        }
        if(strRepresentation == ""){ // Deal with edge case of an empty quaternion
            strRepresentation = "0"
        }
        return strRepresentation
  }
}
