from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here
def first_then_lower_case(strings, predicate, /) -> str:
    for string in strings: #For each string, test the predicate and return the lowercase version of the first string that passes
        if predicate(string):
            return string.lower()
    return None #Otherwise, return None

# Write your powers generator here
def powers_generator(*, base, limit) -> int:
    curr_number = 1
    while curr_number <= limit: #While the current number is below our limit, keep yielding it and multiplying it by the base
        yield curr_number
        curr_number = curr_number * base

# Write your say function here
def say(word = None, /) -> str:
    if word == None: #Check base case
        return ""
    else: #Otherwise, return function that concatenates subsequent calls and recurses
        def say_next(next_word = None, /) -> str:
            if next_word == None: #Check base case
                return word
            else:
                return say(word + " " + next_word)
    return say_next


# Write your line count function here
def meaningful_line_count(filepath) -> int:
    meaningful_lines = 0
    with open(filepath) as file: #Open file
        for line in file: #For each line in the file, remove the brightspace and check if it's empty or starts with "#"
            filtered_line = ''.join(line.split())
            if filtered_line != "" and filtered_line[0] != "#":
                meaningful_lines += 1
        file.close() #Close the file when we're done
    return meaningful_lines


# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion():
    def __init__(self, a, b, c, d) -> object:
        object.__setattr__(self, "a", a)
        object.__setattr__(self, "b", b)
        object.__setattr__(self, "c", c)
        object.__setattr__(self, "d", d)

    def __add__(self, other) -> object:
        return Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)
    
    def __mul__(self, other) -> object:
        # Hamilton product formula taken from: https://en.wikipedia.org/wiki/Quaternion#Hamilton_product 
        return Quaternion(((self.a * other.a) - (self.b * other.b) - (self.c * other.c) - (self.d * other.d)), 
                          ((self.a * other.b) + (self.b * other.a) + (self.c * other.d) - (self.d * other.c)), 
                          ((self.a * other.c) - (self.b * other.d) + (self.c * other.a) + (self.d * other.b)), 
                          ((self.a * other.d) + (self.b * other.c) - (self.c * other.b) + (self.d * other.a)))
    
    @property
    def coefficients(self) -> tuple:
        return (self.a, self.b, self.c, self.d)
    
    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __eq__(self, other) -> bool:
        return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d

    def __str__(self) -> str:
        str_representation = ""
        my_coefficients = self.coefficients
        for index, value in enumerate(my_coefficients): #For each of our values, we need to respond differently based on the values
            if value != 0: #If any of our values are 0, we don't put them in the string (we deal with the empty Quaternion case later)
                if str_representation != "" and value > 0: #If the value is positive and the string isn't empty, add the addition sign
                    str_representation += "+"
                elif value < 0: #If the value is negative, add the negative/subtraction sign
                    str_representation += "-"
                if (value != 1 and value != -1) or index == 0: #If the value isn't +-1 or it's the value with no variable, add the value
                    str_representation += str(abs(value))
                match index: #Depending on the index, add the corresponding variable
                    case 1:
                        str_representation += "i"
                    case 2:
                        str_representation += "j"
                    case 3: 
                        str_representation += "k"
        
        if str_representation == "": # Deal with edge case of an empty quaternion
            str_representation = "0"
        return str_representation