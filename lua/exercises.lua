function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

-- Write your first then lower case function here

function first_then_lower_case(array, predicate)
 for _, element in ipairs(array) do --Check each string to see if it satisfies the predicate and then return the lower case version
  if predicate(element) then
    return string.lower(element)
  end
 end
end

-- Write your powers generator here

function powers_generator(base, limit)
  local power = 1
  return coroutine.create(function()
   while power <= limit do --While the current number is below our limit, keep yielding it and multiplying it by the base
    coroutine.yield(power)
    power = power * base
   end
  end)
end

-- Write your say function here

function say(word)
  if word == nil then --Check base case
    return ""
  end --Otherwise, return function that concatenates subsequent calls and recurses
  return function(next_word)
    if next_word == nil then --Check base case
     return word
    else
      return say(word .. " " .. next_word)
    end
  end
end

-- Write your line count function here
function meaningful_line_count(file_path)
 meaningful_lines = 0
 file = io.open(file_path, "r") --Open the file and then make sure it exists
 if file == nil then
  error("No such file")
 end
 for line in file:lines() do --Loop through the lines
  filtered_line = line:gsub("%s+", "") --Filter the line to remove whitespace
  if filtered_line ~= "" and filtered_line:sub(1, 1) ~= "#" then --Once the whitespace is gone, increment the counter if the line isn't empty or doesn't start with "#"
    meaningful_lines = meaningful_lines + 1
  end
 end
 return meaningful_lines
end

-- Write your Quaternion table here

Quaternion = (function (class)
  class.new = function (a, b, c, d)
    return setmetatable({a = a, b = b, c = c, d = d}, {
      __index = {
        coefficients = function(self)
          return { a, b, c, d }
        end,
        conjugate = function(self)
          return class.new(self.a, -self.b, -self.c, -self.d)
        end
      },
      __add = function(self, other)
        return class.new(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)
      end,
      __mul = function(self, other)
        return class.new(
          ((self.a * other.a) - (self.b * other.b) - (self.c * other.c) - (self.d * other.d)), 
          ((self.a * other.b) + (self.b * other.a) + (self.c * other.d) - (self.d * other.c)), 
          ((self.a * other.c) - (self.b * other.d) + (self.c * other.a) + (self.d * other.b)), 
          ((self.a * other.d) + (self.b * other.c) - (self.c * other.b) + (self.d * other.a))
        )
      end,
      __eq = function(self, other)
        return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
      end,
      __tostring = function(self)
        local variables = {
          --[0] = "",
          [2] = "i",
          [3] = "j",
          [4] = "k"
        }
        local str_representation = ""
        local my_coefficients = self.coefficients()
        for index, value in ipairs(my_coefficients) do
          if value ~= 0 then
            if str_representation ~= "" and value > 0 then --Add an addition sign if there's something before the current value and the value is positive
              str_representation = str_representation .. "+"
            elseif value < 0 then --Add a negative/subtraction sign if the value is negative
              str_representation = str_representation .. "-"
            end
            if (value ~= 1 and value ~= -1) or index == 1 then --We don't want to print +-1 unless it's the first value, which doesn't have a variable attached
              str_representation = str_representation .. tostring(math.abs(value))
            end
            if (index > 1 and index < 5) then --Add variables
              str_representation = str_representation .. variables[index]
            end
          end
        end

        if str_representation == "" then --Deal with edge case of an empty quaternion
          str_representation = "0"
        end
        return str_representation
      end
    })
  end
  return class
end)({})
