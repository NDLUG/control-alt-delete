import json
from typing import Any, Callable, Hashable, Iterable

next_id = 0
mapping = {}


def identify(item: Hashable) -> int:
    global next_id, mapping
    if item in mapping:
        return mapping[item]
    else:
        mapping[item] = next_id
        next_id += 1
        return mapping[item]


def read_file(fname: str) -> dict:
    with open(fname, 'r') as file:
        return json.load(file)


def deep_identify(data: dict) -> dict:
    new_data = {}

    # Map each item to a unique index.
    for key in data:
        new_data[identify(key)] = [
            identify(item)
            for item in data[key]
        ]

    return new_data


def to_adjacency_list(identified: dict) -> list:
    global next_id
    return [
        identified.get(i, [])
        for i in range(next_id)
    ]


def part_a(adj: list, jail_id: int) -> int:
    visited = set()
    queue: list = adj[jail_id].copy()

    # Perform a tree traversal.
    while queue:
        dep = queue.pop()
        if dep not in visited:
            queue.extend(adj[dep])
            visited.add(dep)

    return len(visited)


def part_b(adj: list) -> int:
    # Count the number of leaves.
    for i, val in enumerate(adj):
        if not val:
            # name = [k for k, v in mapping.items() if v == i][0]
            # print(i, name, 'depends on no-one')
            pass
        
    return len([
        1 for item in adj
        if not item
    ])


def toposort(adj: list) -> list:
    indeg = [0] * len(adj)

    # Find vertices with in-degree zero.
    for llist in adj:
        for num in llist:
            indeg[num] += 1

    output = []
    queue = [i for i, deg in enumerate(indeg) if deg == 0]

    # Traverses all nodes in graph.
    while queue:
        i = queue.pop()
        output.append(i)
        for next in adj[i]:
            indeg[next] -= 1
            if indeg[next] == 0:
                queue.append(next)

    return output


def visualize(adj: list, topo: list):
    global mapping
    topo = topo.copy()
    visited = set()
    queue = [(topo.pop(0), '')]
    while queue:
        i, prefix = queue.pop()
        if i not in visited:
            name = [k for k, v in mapping.items() if v == i][0]
            print(prefix, name, '*' if not adj[i] else '')

            # Uncomment to disallow duplicates.
            # visited.add(i)

            # Find children that we haven't printed.
            for next in adj[i]:
                queue.append((next, prefix + '   '))
        
        # Refresh queue.
        if not queue and topo:
            queue.append((topo.pop(0), ''))


raw = read_file('input.txt')
raw = deep_identify(raw)
raw = to_adjacency_list(raw)
jail_id = mapping['jailbreak']

if True:
    # Visualize the graph.
    topo = toposort(raw)
    # visualize(raw, topo)

a = part_a(raw, jail_id)
print('Number of Dependencies:', a)

b = part_b(raw)
print('Maximum Concurrency:', b)
