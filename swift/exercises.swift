import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

//First than lower case function - takes a list of strings and returns the lowercase version of the first string that fulfills the predicate
func firstThenLowerCase(of strings: [String], satisfying predicate: (String)->Bool) -> String?{
    return strings.first(where: predicate)?.lowercased()
}

//Speaker struct for say function
struct Speaker{
    let phrase: String
    func and(_ nextWord: String = "") -> Speaker{
        return Speaker(phrase: phrase + " " + nextWord)
    }
}

//Say function which can deal with both the empty argument and string argument cases
func say(_ word: String = "") -> Speaker{
    return Speaker(phrase: word)
}

//Meaningful line count function - returns the number of lines in a file that aren't blank or start with "#"
func meaningfulLineCount(_ filepath: String) async -> Result<Int, NoSuchFileError>{
    var count: Int = 0
    do{
        let url = URL(fileURLWithPath: filepath)
        for try await line in url.lines {
            if (!line.trimmingCharacters(in: .whitespaces).isEmpty && !line.trimmingCharacters(in: .whitespaces).hasPrefix("#")){
                count += 1
            }
        }
        return .success(count)
    } catch {
        return .failure(NoSuchFileError())
    }
}

//Quaternion struct
struct Quaternion: CustomStringConvertible, Equatable{
    let a, b, c, d: Double

    static let ZERO = Quaternion(a: 0.0, b: 0.0, c: 0.0, d: 0.0)
    static let I = Quaternion(a: 0.0, b: 1.0, c: 0.0, d: 0.0)
    static let J = Quaternion(a: 0.0, b: 0.0, c: 1.0,  d: 0.0)
    static let K = Quaternion(a: 0.0, b: 0.0, c: 0.0, d: 1.0)

    init(a: Double = 0.0, b: Double = 0.0, c: Double = 0.0, d: Double = 0.0){
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    var coefficients: [Double] {return [a, b, c, d]}

    var conjugate: Quaternion {return Quaternion(a: a, b: -b, c: -c, d: -d)}

    static func +(left: Quaternion, right: Quaternion) -> Quaternion{
        return Quaternion(a: left.a + right.a, b: left.b + right.b, c: left.c + right.c, d: left.d + right.d)
    }

    static func *(left: Quaternion, right: Quaternion) -> Quaternion{
        return Quaternion(
            a: ((left.a * right.a)-(left.b * right.b)-(left.c * right.c)-(left.d * right.d)),
            b: ((left.a * right.b)+(left.b * right.a)+(left.c * right.d)-(left.d * right.c)),
            c: ((left.a * right.c)-(left.b * right.d)+(left.c * right.a)+(left.d * right.b)),
            d: ((left.a * right.d)+(left.b * right.c)-(left.c * right.b)+(left.d * right.a))
        )
    }

    var description: String{
        //Zero case
        if(self.coefficients == Quaternion.ZERO.coefficients){
            return "0"
        }
        var desc: String = ""
        if (a != 0.0){
            desc += String(a)
        }
        //For each coefficient, add it's operation character, value, and variable depending on the coefficient's value
        for i in 1...3{
            if(self.coefficients[i] != 0.0){
                desc += (self.coefficients[i] > 0.0 && desc != "") ? "+":""
                desc += self.coefficients[i] < 0.0 ? "-":""
                desc += (abs(self.coefficients[i]) != 1 || i == 0) ? String(abs(self.coefficients[i])) : ""
                switch (i){
                    case 1:
                        desc += "i";
                        break;
                    case 2:
                        desc += "j";
                        break;
                    case 3:
                        desc += "k";
                        break;
                    default:
                        break;
                }
            }
        }
        return desc
    }
}

//BST enum
enum BinarySearchTree: CustomStringConvertible {
    case empty
    indirect case node(BinarySearchTree, String, BinarySearchTree)

    var size: Int {
        switch self {
            case .empty:
                return 0
            case let .node(left, _, right):
                return 1 + left.size + right.size
        }
    }

    func contains(_ value: String) -> Bool{
        switch self{
            case .empty:
                return false
            case let .node(left, nodeValue, right):
                if value < nodeValue{
                    return left.contains(value)
                } else if value > nodeValue{
                    return right.contains(value)
                } else {
                    return true
                }
        }
    }

    func insert(_ value: String) -> BinarySearchTree{
        switch self{
            case .empty:
                return .node(.empty, value, .empty)
            case let .node(left, nodeValue, right):
                if value < nodeValue{
                    return .node(left.insert(value), nodeValue, right)
                } else if value > nodeValue{
                    return .node(left, nodeValue, right.insert(value))
                } else {
                    return .node(left, nodeValue, right)
                }

        }
    }

    var description: String{
        switch self{
            case .empty:
                return "()"
            case let .node(left, nodeValue, right):
                return "(" 
                + ((left.size > 0) ? String(describing: left) + nodeValue : nodeValue) 
                + (right.size > 0 ? String(describing: right) + ")" : ")")
        }
        
    }
}