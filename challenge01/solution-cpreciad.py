#!/usr/bin/env python3
import sys

KEY = 'UNIX'

def read_input():
    try:
        message_type, coded_message = sys.stdin.readline().strip().split()
    except ValueError:
        return None

    return coded_message


def caesar_cypher(key_letter, letter):
    spaces = ord(key_letter) - ord('A')
    return chr(int((((ord(letter) - 65) - spaces) % 26) + 65))

def replicate_key(message_len):
    new_key = []

    for i in range(message_len):
        index = i % len(KEY)

        new_key.append(KEY[index])
    return ''.join(new_key)

def decipher_code(coded_message):
    key = replicate_key(len(coded_message))
    
    message = []
    for i in range(len(coded_message)):
        message.append(caesar_cypher(key[i], coded_message[i]))

    return ''.join(message)

def main():
    while coded_message := read_input():
        coded_password = read_input()
        print(f'Username: {decipher_code(coded_message)}')
        print(f'Password: {decipher_code(coded_password)}')

if __name__ == "__main__":
    main()
