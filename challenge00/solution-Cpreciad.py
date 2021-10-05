#!/usr/bin/env python3
import sys
import itertools

def read_input():
    drinks = [int(num) for num in sys.stdin.readline().strip().split()]
    return drinks

def count_min_steps(drinks):
    n = len(drinks)
    table = [sys.maxsize] * n

    table[0] = 1

    for i in range(n):
        for step in range(drinks[i] + 1):
            if step == 0:
                continue
            if i + step >= n:
                break

            table[i+step] = min(table[i + step], table[i]+1)

    #print(table)
    return table[n-1]

def main():
    while drinks := read_input():
        
        # function for part A.
        print(f'Part A: {count_min_steps(drinks)}')
        
        # function for part B. 
        min_steps = sys.maxsize
        for perm in itertools.permutations(drinks):
            min_steps = min(min_steps, count_min_steps(perm))
        print(f'Part B: {min_steps}')


if __name__ == "__main__":
    main()
