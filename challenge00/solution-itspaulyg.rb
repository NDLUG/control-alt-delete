#!/usr/bin/env ruby
# Ruby solution by itspaulyg

# Rearranging means we want to use the
# max values as much as we can;
# get to the end in the quickest manner


def minimum_rearranged_drinks(drinks)

  # if there is only one drink then 
  # Tux only drinks one 
  n = drinks.length
  if n == 1
    return 1
  end

  n -= 1

  count = 0
  i = 0
  while i < n
    # get current max and delete it from array
    i += drinks.max
    drinks.delete_at(drinks.index(drinks.max))

    # i >= n means we are done but we must add
    # the final drink at the end so add 2
    # otherwise add one for that drink
    if i >= n 
      count += 2
    else
      count += 1
    end
  end

  return count

end


def minimum_drinks(drinks)

  # if there is only one drink then 
  # Tux only drinks one 
  n = drinks.length
  if n == 1 
    return 1
  end

  # subtract one because of 0 indexing
  n -= 1

  i = 0
  count = 1
  while i < n

    # this loop finds the max where the max
    # is the value plus its index in the range 
    # of places we can go from the previous drink
    # tmp is the index of that value
    max = 0
    for j in (i+1..i+drinks[i])
      if max <= drinks[j]+j
        max = drinks[j]+j
        tmp = j
      end
    end

    # max >= n means we are done but we must add
    # the final drink at the end so add 2
    # otherwise add one for that drink
    if max >= n
        count += 2
        break
    else
      count += 1
    end

    # then our index i becomes the index where
    # the max is located 
    i = tmp

  end 

  return count

end 

# get input as integers
drinks = gets.split().map!(&:to_i)

# Part A execution 
min_drinks = minimum_drinks drinks
print "Part A: ", min_drinks, "\n"

# Part B execution
opt_min_drinks = minimum_rearranged_drinks drinks
print "Part B: ", opt_min_drinks, "\n"
