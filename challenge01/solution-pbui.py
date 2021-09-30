#!/usr/bin/env python3

# Challenge 01: Cipher

import itertools
import sys

# Constants

KEY      = 'UNIX'
ALPHABET = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

# Functions

def caesar_decrypt(c, n):
    '''
    >>> caesar_decrypt('b', 1)
    'A'
    >>> caesar_decrypt('B', 13)
    'O'
    >>> caesar_decrypt('B', 28)
    'Z'
    '''
    return ALPHABET[((ord(c.upper()) - ord('A')) - n) % len(ALPHABET)] 

def caesar_encrypt(c, n):
    '''
    >>> caesar_encrypt('a', 1)
    'B'
    >>> caesar_encrypt('O', 13)
    'B'
    >>> caesar_encrypt('z', 28)
    'B'
    '''
    return ALPHABET[((ord(c.upper()) - ord('A')) + n) % len(ALPHABET)] 

def cipher_decrypt(s, key=KEY):
    '''
    >>> cipher_decrypt('LXFOPVEFRNHR', 'lemon')
    'ATTACKATDAWN'
    
    >>> cipher_decrypt('ngmni', 'key')
    'DCODE'
    '''
    key       = itertools.cycle(key.upper())
    plaintext = [caesar_decrypt(c, ord(k) - ord('A')) for c, k in zip(s, key)]
    return ''.join(plaintext)

def cipher_encrypt(s, key=KEY):
    '''
    >>> cipher_encrypt('attackatdawn', 'lemon')
    'LXFOPVEFRNHR'
    
    >>> cipher_encrypt('dcode', 'key')
    'NGMNI'
    '''
    key        = itertools.cycle(key.upper())
    ciphertext = [caesar_encrypt(c, ord(k) - ord('A')) for c, k in zip(s, key)]
    return ''.join(ciphertext)

# Main Execution

def main():
    username = sys.stdin.readline().split(':')[-1].strip()
    password = sys.stdin.readline().split(':')[-1].strip()

    print(f'Username: {cipher_decrypt(username)}')
    print(f'Password: {cipher_decrypt(password)}')
    
if __name__ == '__main__':
    main()
