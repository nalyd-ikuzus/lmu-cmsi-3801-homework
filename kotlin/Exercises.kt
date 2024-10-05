import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException
import kotlin.math.absoluteValue

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

//First than lower case function - takes a list of strings and returns the lowercase version of the first string that fulfills the predicate
fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String?{
    return strings.firstOrNull(predicate)?.lowercase()
}

//Speaker data class for say function
data class Speaker(val phrase: String){
    fun and(word: String): Speaker{
        return Speaker("$phrase $word")
    }
}
//Say function which can deal with both the empty argument and string argument cases
fun say(phrase: String = ""): Speaker{
    return Speaker(phrase)
}

//Meaningful line count function - returns the number of lines in a file that aren't blank or start with "#"
@Throws(IOException::class)
fun meaningfulLineCount(path: String): Long{
    BufferedReader(FileReader(path)).use { reader ->
        return reader.lines().filter {it.trim().isNotEmpty() && !it.trim().startsWith("#")}.count()
    }
}

//Quaternion data class
data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double){
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(other: Quaternion): Quaternion{
        return Quaternion(this.a + other.a, this.b + other.b, this.c + other.c, this.d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion{
        return Quaternion(
            ((this.a * other.a)-(this.b * other.b)-(this.c * other.c)-(this.d * other.d)),
            ((this.a * other.b)+(this.b * other.a)+(this.c * other.d)-(this.d * other.c)),
            ((this.a * other.c)-(this.b * other.d)+(this.c * other.a)+(this.d * other.b)),
            ((this.a * other.d)+(this.b * other.c)-(this.c * other.b)+(this.d * other.a))
            )
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)

    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)

    override fun toString(): String{
        //Zero case
        if(this.coefficients() == ZERO.coefficients()){
            return "0"
        }
        //Otherwise, start building the string
        return buildString(builderAction = { 
            var stringEmpty = true
            if (a != 0.0) {
                append(a)
                stringEmpty = false
            }
            //For each coefficient, add it's operation character, value, and variable depending on the coefficient's value
            val myCoefficients = coefficients()
            for (i in 1..3) {
                if (myCoefficients[i] != 0.0) {
                    if (myCoefficients[i] > 0.0 && !stringEmpty){
                        append("+")
                    } else if (myCoefficients[i] < 0.0) {
                        append("-")
                    }
                    if (myCoefficients[i].absoluteValue != 1.0){
                        append(myCoefficients[i].absoluteValue)
                        stringEmpty = false
                    }
                    when(i) {
                        1 -> {
                            append("i")
                            stringEmpty = false
                            }
                        2 -> {
                            append("j")
                            stringEmpty = false
                            }
                        3 -> {
                            append("k")
                            stringEmpty = false
                            }
                    }
                }
            }
        })
    }
}

//BST interface
sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree

    //Empty tree
    object Empty : BinarySearchTree{
        override fun size() = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)
        override fun toString(): String = "()"
    }

    //BST node
    data class Node(private val value: String, private val left: BinarySearchTree, private val right: BinarySearchTree): BinarySearchTree{
        override fun size() = 1 + left.size() + right.size()
        override fun contains(value: String): Boolean = when {
            value < this.value -> left.contains(value)
            value > this.value -> right.contains(value)
            else -> true
        }
        override fun insert(value: String): BinarySearchTree = when {
            value < this.value -> Node(this.value, left.insert(value), right)
            value > this.value -> Node(this.value, left, right.insert(value))
            else -> this
        }

        override fun toString(): String {
            return buildString{
                append("(")
                if (left.size() > 0){
                    append(left)
                }
                append(value)
                if(right.size() > 0){
                    append(right)
                }
                append(")")
            }
        }
    }
}