#!/usr/bin/env python3

# Challenge 03: Packages

import collections
import json
import sys

# Functions

def determine_dependencies(graph):
    frontier = ['jailbreak']
    visited  = set()

    while frontier:
        vertex = frontier.pop()

        if vertex in visited:
            continue

        visited.add(vertex)

        for neighbor in graph[vertex]:
            frontier.append(neighbor)

    return len(visited) - 1

def determine_width(graph):
    degrees = collections.defaultdict(int)
    for vertex in graph:
        degrees[vertex]
        for neighbor in graph[vertex]:
            degrees[neighbor] += 1

    frontier = [(v, 0, v == 'jailbreak') for v in degrees if degrees[v] == 0]
    levels   = collections.defaultdict(set)

    while frontier:
        vertex, level, jailbreak = frontier.pop()
        if level and jailbreak:
            levels[level].add(vertex)

        for neighbor in graph[vertex]:
            degrees[neighbor] -= 1
            if degrees[neighbor] == 0:
                frontier.append((neighbor, level + 1, jailbreak))

    return len(max(levels.values(), key=len))

# Main Execution

def main():
    graph        = json.loads(sys.stdin.read())
    dependencies = determine_dependencies(graph)
    width        = determine_width(graph)

    print(f'Number of Dependencies: {dependencies}')
    print(f'Maximum Concurrency: {width}')

if __name__ == '__main__':
    main()
