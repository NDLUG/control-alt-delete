#!/usr/bin/env python3

from scipy.sparse import csr_matrix
from scipy.sparse.csgraph import dijkstra
import sys

#def sort_insert(new_x, xs):
#    lower = 0       # inclusive
#    upper = len(xs) # exclusive
#    while upper - lower > 1:
#        mid = (lower + upper) // 2
#        if new_x == xs[mid]:
#            lower = mid
#            upper = mid + 1
#        elif new_x > xs[mid]:
#            lower = mid + 1
#        elif new_x < xs[mid]:
#            upper = mid # TODO: +1?
#    xs.insert(lower, new_x)

#def my_dijkstra(graph, src):
#    dists = [float('inf') for _ in graph]
#    dists[src] = 0
#    

def parse_maze(maze):
    graph = []
    src = None
    dst = None

    for line in maze:
        row = []
        for c in line.strip():
            if c == 'j':
                src = (len(graph), len(row))
            elif c == 'x':
                dst = (len(graph), len(row))
            row.append(c != 'w')
        graph.append(row)
    return graph, src, dst, len(graph), len(graph[0])

graph, src, dst, rows, cols = parse_maze(sys.stdin)

def get_abs_index(pos=None, row=None, col=None):
    if pos: row, col = pos
    return row * cols + col

def cartesian(xs, ys):
    for x in xs:
        for y in ys:
            yield (x, y)

def can_move_to(pos, wall_weight=0):
    row, col = pos
    if 0 <= row < rows and 0 <= col < cols:
        return 1 if graph[row][col] else wall_weight
    else:
        return 0

def make_edge_entry(row_a, col_a, wall_weight=0):
    entry = [0 for _ in range(rows*cols)]
    if can_move_to((row_a, col_a), wall_weight=wall_weight):
        ps = [(row_a + 1, col_a), (row_a - 1, col_a), (row_a, col_a + 1), (row_a, col_a - 1)]
        for pos_b in ps:
            c = can_move_to(pos_b, wall_weight=wall_weight)
            if c: entry[get_abs_index(pos=pos_b)] = c
    return entry


def make_edgegraph(wall_weight):
    return [make_edge_entry(row_a, col_a, wall_weight=wall_weight) for (row_a, col_a) in cartesian(range(rows), range(cols))]

def compute_dist(edgegraph):
    return int(dijkstra(csgraph=csr_matrix(edgegraph), directed=True, indices=get_abs_index(pos=src))[get_abs_index(pos=dst)]) + 1

edgegraphA = make_edgegraph(0)
edgegraphB = make_edgegraph(2)

print("Part A:", compute_dist(edgegraphA))
print("Part B:", compute_dist(edgegraphB))
