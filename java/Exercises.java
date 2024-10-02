import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import java.lang.Math;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // Write your first then lower case function here
    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream() //Grab stream of strings so we can perform some aggregate operations
                .filter(predicate)  //Filter for the predicate
                .findFirst()    //Grab first
                .map(String::toLowerCase);  //Make that string lowercase
    }

    // Write your say function here
    ///Speaker class for the say method
    static class Speaker{
        //Phrase of the current speaker
        private String phrase;

        //Constructor
        public Speaker(String initialPhrase){
            this.phrase = initialPhrase;
        }

        //And method -> returns a new Speaker with the extended phrase
        public Speaker and(String word){
            return new Speaker(this.phrase + " " + word);
        }

        //Phrase getter method
        public String phrase(){
            return this.phrase;
        }
    }

    //Say method for empty argument case
    public static Speaker say(){
        return new Speaker("");
    }

    //Say method for String argument case
    public static Speaker say(String word){
        return new Speaker(word);
    }

    // Write your line count function here
    public static int meaningfulLineCount(String path) throws IOException{
        try (var reader = new BufferedReader(new FileReader(path))) {
            return (int) reader.lines()
                            .filter(line -> !line.trim().isBlank() && !line.trim().startsWith("#"))
                            .count();
        }
    }
}

// Write your Quaternion record class here
record Quaternion(double a, double b, double c, double d) {
    public Quaternion{
        if(a != a || b != b || c != c || d != d){
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }
    //Static pre-made Quaternions
    public final static Quaternion ZERO = new Quaternion(0.0, 0.0, 0.0, 0.0);
    public final static Quaternion I = new Quaternion(0.0, 1.0, 0.0, 0.0);
    public final static Quaternion J = new Quaternion(0.0, 0.0, 1.0, 0.0);
    public final static Quaternion K = new Quaternion(0.0, 0.0, 0.0, 1.0);

    Quaternion plus(Quaternion other){
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }

    Quaternion times(Quaternion other){
        return new Quaternion(
                            ((a * other.a)-(b * other.b)-(c * other.c)-(d * other.d)),
                            ((a * other.b)+(b * other.a)+(c * other.d)-(d * other.c)),
                            ((a * other.c)-(b * other.d)+(c * other.a)+(d * other.b)),
                            ((a * other.d)+(b * other.c)-(c * other.b)+(d * other.a))
                            );
    }

    public Quaternion conjugate(){
        return new Quaternion(a, -b, -c, -d);
    }

    public List<Double> coefficients(){
        return List.of(a, b, c, d);
    }

    @Override
    public String toString(){
        //Zero case
        if(this.coefficients().equals(ZERO.coefficients())){
            return "0";
        }
        //Non-zero case
        String strRepresentation = "";
        List<Double> myCoefficients = coefficients();
        for (int i = 0; i < myCoefficients.size(); i ++){
            double coefficient = myCoefficients.get(i);
            //System.out.print("\n" + coefficient);
            if (coefficient != 0.0){
                strRepresentation += (coefficient > 0.0 && !strRepresentation.isBlank()) ? "+" : "";
                strRepresentation += (coefficient < 0.0) ? "-" : "";
                strRepresentation += ((Math.abs(coefficient) != 1) || i == 0) ? Math.abs(coefficient) : "";
                switch (i){
                    case 1:
                        strRepresentation += "i";
                        break;
                    case 2:
                        strRepresentation += "j";
                        break;
                    case 3:
                        strRepresentation += "k";
                        break;
                    default:
                        break;
                }
            }
        }
        //System.out.print("\n" + strRepresentation);
        return strRepresentation;
    }
    
}


// Write your BinarySearchTree sealed interface and its implementations here
sealed interface BinarySearchTree permits Empty, Node{
    int size();

    boolean contains(String value);

    BinarySearchTree insert(String value);
}

final record Empty() implements BinarySearchTree{
    @Override
    public int size(){
        return 0;
    }

    @Override
    public boolean contains(String value){
        return false;
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, this, this);
    }

    @Override
    public String toString(){
        return "()";
    }
}

final class Node implements BinarySearchTree{
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }

    @Override
    public boolean contains(String value) {
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }

    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0){
            return new Node(this.value, left.insert(value), right);
        } else {
            return new Node(this.value, left, right.insert(value));
        }
    }

    @Override
    public String toString() {
        String BSTString = "(" + (left.size() > 0 ? left + value: value);
        BSTString += right.size() > 0 ? right + ")": ")";
        return BSTString;
    }
}