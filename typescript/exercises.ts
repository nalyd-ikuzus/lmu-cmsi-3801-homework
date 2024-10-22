import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(items: T[], predicate: (item: T) => boolean, consumer: (item: T) => U): U | undefined {
  const first = items.find(predicate)
  if (first != undefined){
    return consumer(first)
  }
  return undefined
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  for (let power = BigInt(1); ; power *= base){
    yield power
  }
}

export async function meaningfulLineCount(filePath: string): Promise<number> {
  let meaningfulLines = 0
  const file = await open(filePath, "r") //Open the file
  for await (const line of file.readLines()) { //For each line in the file, filter for whitespace and check to see if it has meaning
    const filteredLine = line.replace(/\s+/g, "")
    if(filteredLine != "" && !filteredLine.startsWith("#")){
      meaningfulLines += 1
    }
  }
  file.close()
  return meaningfulLines
}

interface Sphere{
  kind: "Sphere"
  radius: number
}

interface Box {
  kind: "Box"
  width: number
  length: number
  depth: number
}

export type Shape = Sphere | Box

export function surfaceArea(shape: Shape): number {
  switch(shape.kind) {
    case "Sphere":
      return 4 * Math.PI * shape.radius ** 2
    case "Box":
      return 2 * (shape.width * shape.length + shape.width * shape.depth + shape.length * shape.depth)
  }
}

export function volume(shape: Shape): number {
  switch(shape.kind) {
    case "Sphere":
      return ((4/3) * Math.PI * shape.radius ** 3)
    case "Box":
      return (shape.width * shape.length * shape.depth)
  }
}

// Write your binary search tree implementation here
export interface BinarySearchTree<T> {
  size(): number
  insert(value: T): BinarySearchTree<T>
  contains(value: T): boolean
  inorder(): Iterable<T>
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0
  }
  insert(value: T): BinarySearchTree<T> {
      return new Node(value, new Empty(), new Empty())
  }
  contains(value: T): boolean {
      return false
  }
  inorder(): Iterable<T> {
      return []
  }
  public toString(): String{
    return "()"
  }
}

class Node<T> implements BinarySearchTree<T> {
  private value!: T
  private left!: BinarySearchTree<T>
  private right!: BinarySearchTree<T>

  constructor(value: T, left: BinarySearchTree<T>, right: BinarySearchTree<T>){
    this.value = value
    this.left = left
    this.right = right
  }
  size(): number {
      return 1 + this.left.size() + this.right.size()
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value && !this.contains(value)){
      return new Node(this.value, this.left.insert(value), this.right);
    } else if (!this.contains(value)){
      return new Node(this.value, this.left, this.right.insert(value));
    } else {
      return this
    }
  }

  contains(value: T): boolean {
    return this.value == value || this.left.contains(value) || this.right.contains(value);
  }

  *inorder(): Iterable<T> {
    if(this.size() == 0){
      return;
    }

    yield* this.left.inorder()

    yield this.value

    yield* this.right.inorder()
  }

  public toString(): String {
    return `(${this.left.size() != 0 ? this.left : ""}${this.value}${this.right.size() != 0 ? this.right : ""})`
  }
}