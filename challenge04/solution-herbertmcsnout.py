#!/usr/bin/env python3
import sys

class MinQElem:
    def __init__(self, value, weight):
        self.value = value
        self.weight = weight
        
    def __lt__(self, other): return self.weight < other
    def __gt__(self, other): return self.weight > other
    def __eq__(self, other): return self.weight == other
    def __ge__(self, other): return self.weight >= other
    def __le__(self, other): return self.weight <= other

    def __str__(self): return str((self.value, self.weight))
    def __repr__(self): return repr((self.value, self.weight))


class MinQueue:
    def __init__(self, queue=None):
        self.queue = sorted(queue) if queue else []

    def insert(self, x):
        i = self.indexof(x.weight)
        self.queue.insert(i, x)

    def __bool__(self):
        return bool(self.queue)

    def pop(self):
        return self.queue.pop(0)

    def indexof(self, x):
        lower = 0               # inclusive
        upper = len(self.queue) # exclusive
        while upper - lower > 1:
            mid = (lower + upper) // 2
            if x == self.queue[mid]:
                lower = mid
                upper = mid + 1
            elif x > self.queue[mid]:
                lower = mid + 1
            elif x < self.queue[mid]:
                upper = mid
        if lower < len(self.queue) and self.queue[lower] < x:
            lower += 1

        if isinstance(x, MinQElem):
            # Now, if there are multiple elems with same weight, pick one with correct value
            # Search backwards from lower (inclusive)
            i = lower
            while i >= 0 and self.queue[i] == x:
                if self.queue[i].value == x.value:
                    return i
                i -= 1
    
            # Search forwards from lower (exlusive)
            i = lower + 1
            while i < len(self.queue) and self.queue[i] == x:
                if self.queue[i].value == x.value:
                    return i
                i += 1
        else:
            return lower

    def update(self, old, new):
        i = self.indexof(old)
        del self.queue[i]
        self.insert(new)

def my_dijkstra(graph, src):
    dists = [MinQElem(v, 0 if v == src else float('inf')) for v in range(len(graph))]
    visited = [False for _ in dists]
    queue = MinQueue(dists)
    while queue:
        u = queue.pop()
        visited[u.value] = True
        for v_i, u2v in enumerate(graph[u.value]):
            if 0 < u2v < float('inf') and not visited[v_i]:
                v = dists[v_i]
                v_alt = MinQElem(v_i, u.weight + u2v)
                if v_alt < v:
                    queue.update(v, v_alt)
                    v.weight = v_alt.weight
    return [v.weight for v in dists]
    

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
