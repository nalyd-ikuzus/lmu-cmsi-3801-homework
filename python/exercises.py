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
    for string in strings:
        if predicate(string):
            return string.lower()
    return None

# Write your powers generator here
def powers_generator(*, base, limit) -> int:
    curr_number = 1
    while curr_number <= limit:
        yield curr_number
        curr_number = curr_number * base
    # else:
    #     raise StopIteration

# Write your sab function here
def say(word = None, /) -> str:
    if word == None:
        return ""
    else:
        def say_next(next_word = None, /) -> str:
            if next_word == None:
                return word
            else:
                return say(word + " " + next_word)
    return say_next


# Write your line count function here
def meaningful_line_count(filepath) -> int:
    meaningful_lines = 0
    #print("\n\n")
    with open(filepath) as file:
        for line in file:
            filtered_line = ''.join(line.split())
            #print("START" + filtered_line + "END")
            if filtered_line != "" and filtered_line[0] != "#":
                meaningful_lines += 1
        file.close()
    #print(meaningful_lines)
    return meaningful_lines


# Write your Quaternion class here
class Quaternion():
    def __init__(self, a, b, c, d) -> object:
        self.a = a
        self.b = b
        self.c = c
        self.d = d

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
        for index, value in enumerate(my_coefficients):
            if value == 0:
                pass
            else:
                if str_representation != "" and value > 0:
                    str_representation += "+"
                elif value < 0:
                    str_representation += "-"
                if (value != 1 and value != -1) or index == 0:
                    str_representation += str(abs(value))
                match index: #says using a match statement is a problem in vscode but since my python3 in the terminal is 3.11.x it's fine
                    case 0:
                        pass
                    case 1:
                        str_representation += "i"
                    case 2:
                        str_representation += "j"
                    case 3: 
                        str_representation += "k"
                    case _:
                        pass
        
        if str_representation == "": # Deal with edge case of an empty quaternion
            str_representation = "0"
        #print("\n", self.coefficients, "STR:" + str_representation)
        return str_representation