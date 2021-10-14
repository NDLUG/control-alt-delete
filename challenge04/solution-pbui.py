#!/usr/bin/env python3

import collections
import heapq
import sys

# Constants

WEIGHTS_A = {
    'j' : 1,
    'x' : 1,
    '.' : 1,
    'w' : sys.maxsize,
}

WEIGHTS_B = {
    'j' : 1,
    'x' : 1,
    '.' : 1,
    'w' : 2,
}

# Structures

Cell = collections.namedtuple('Cell', 'tile neighbors')

# Functions

def read_graph():
    maze    = [row.strip() for row in sys.stdin]
    rows    = len(maze)
    columns = len(maze[0])
    graph   = {}

    for rindex, row in enumerate(maze):
        for cindex, tile in enumerate(row):
            tindex = rindex * len(row) + cindex
            graph[tindex] = Cell(
                tile,
                make_neighbors(rindex, cindex, rows, columns)
            )

            if tile == 'j':
                start = tindex
            if tile == 'x':
                end   = tindex

    return graph, start, end

def make_neighbors(rindex, cindex, rows, columns):
    neighbors = []

    if rindex > 0:              # Add above
        neighbors.append((rindex - 1)*columns + cindex)

    if rindex < (rows - 1):     # Add below
        neighbors.append((rindex + 1)*columns + cindex)

    if cindex > 0:              # Add left
        neighbors.append(rindex*columns + cindex - 1)
    
    if cindex < (columns - 1):  # Add right
        neighbors.append(rindex*columns + cindex + 1)

    return neighbors

def walk_graph(graph, start, end, weights):
    frontier = [(1, start)]
    visited  = set()
    distance = sys.maxsize

    while frontier:
        distance, vertex = heapq.heappop(frontier)
        
        if vertex == end:
            break

        if vertex in visited:
            continue

        visited.add(vertex)

        for neighbor in graph[vertex].neighbors:
            weight = weights[graph[neighbor].tile]
            heapq.heappush(frontier, (distance + weight, neighbor))

    return distance

# Main Execution

def main():
    graph, start, end = read_graph()

    print(f'Part A: {walk_graph(graph, start, end, WEIGHTS_A)}')
    print(f'Part B: {walk_graph(graph, start, end, WEIGHTS_B)}')

if __name__ == '__main__':
    main()
