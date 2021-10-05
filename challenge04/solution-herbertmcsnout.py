#!/usr/bin/env python3
import sys

class MinQueue:
    def __init__(self, queue=None):
        if queue: self.queue = sorted(queue, key=lambda x: x[1])
        else: self.queue = []

    def insert(self, value, weight):
        lower = 0               # inclusive
        upper = len(self.queue) # exclusive
        while upper - lower > 1:
            mid = (lower + upper) // 2
            if weight == self.queue[mid][1]:
                lower = mid
                upper = mid + 1
            elif weight > self.queue[mid][1]:
                lower = mid + 1
            elif weight < self.queue[mid][1]:
                upper = mid
        self.queue.insert(lower, (value, weight))

    def __bool__(self):
        return bool(self.queue)

    def pop(self):
        return self.queue.pop(0)

    def update(self, value, new_weight):
        # TODO: This is not very efficient
        for i, (old_val, old_weight) in enumerate(self.queue):
            if old_val == value:
                del self.queue[i]
                self.insert(value, new_weight)
                break

def my_dijkstra(graph, src):
    dists = [float('inf') for _ in graph]
    dists[src] = 0
    visited = [False for _ in graph]
    queue = MinQueue([(v, dists[v]) for v in range(len(graph))])
    while queue:
        u, _ = queue.pop()
        for v, w in enumerate(graph[u]):
            if w:
                alt = dists[u] + w
                if alt < dists[v]:
                    dists[v] = alt
                    queue.update(v, alt)
    return dists
    

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
    return my_dijkstra(edgegraph, get_abs_index(pos=src))[get_abs_index(pos=dst)] + 1

print("Part A:", compute_dist(make_edgegraph(0)))
print("Part B:", compute_dist(make_edgegraph(2)))
