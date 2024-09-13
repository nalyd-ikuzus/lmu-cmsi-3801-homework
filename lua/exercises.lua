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
 
end

-- Write your powers generator here

function powers_generator(base, limit)
  local power = 1
  return coroutine.create(function()
   while power <= limit do
    coroutine.yield(power)
    power = power * base
  end)
end

-- Write your say function here

function say(word)
  if word == nil then
    return ""
  end
  return function(next_word)
    if next_word == nil then
     return word
    else
      return say(word .. " " .. next_word)
  end
end

-- Write your line count function here
function meaningful_line_count()

end

-- Write your Quaternion table here

Quaternion = (function (class)
  class.new = function (x, y, z, w)
    return {x = x, y = y, z = z, w = w}
  end

end)({})
