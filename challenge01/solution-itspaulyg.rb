#!/usr/bin/env ruby
# Ruby solution by itspaulyg

def decrypt(uname, pword, key)
  alphabet = ("A".."Z").to_a
  cipher_table = Hash.new()
  for i in (0...alphabet.length)
    k = 0
    cipher_table[alphabet[i]] = Hash.new()
    for j in (i...i+alphabet.length)
      cipher_table[alphabet[i]][alphabet[j % alphabet.length]] = alphabet[k]
      k += 1
    end
  end

  i = 0
  de_uname = Array.new()
  for let in uname.split("")
    de_uname.push(cipher_table[key[i % key.length]][let])
    i += 1
  end

  i = 0
  de_pword = Array.new()
  for let in pword.split("")
    de_pword.push(cipher_table[key[i % key.length]][let])
    i += 1
  end

  return de_uname.join, de_pword.join
end

uname = gets.split(" ")[1].strip()
pword = gets.split(" ")[1].strip()

key = ["U", "N", "I", "X"]

user, pw = decrypt uname, pword, key
print "Username: ", user, "\n"
print "Password: ", pw, "\n"
