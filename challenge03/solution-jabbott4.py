import sys
import json

def read_input() -> dict:
    raw = sys.stdin.read().strip()
    return json.loads(raw)

def visited_bfs(edges: dict, start) -> set:
    # Return all nodes visited from BFS starting at start.
    visited = set()
    queue = [start]

    while queue:
        name = queue.pop()
        visited.add(name)
        for child in edges[name]:
            if child not in visited:
                queue.append(child)

    return visited


def remove_non_jb(edges: dict) -> dict:
    # Remove edges that are not affiliated with 'jailbreak'.
    visited = visited_bfs(edges, 'jailbreak')
    return {k: v for k, v in edges.items() if k in visited}


mapping = {}
revmapp = {}
next_id = 0


def identify(token: str) -> int:
    global mapping, revmapp, next_id
    if token not in mapping:
        mapping[token] = next_id
        revmapp[next_id] = token
        next_id += 1
    return mapping[token]


def deep_identify(data: dict) -> dict:
    # Convert edges to integer identifiers.
    return {
        identify(token): [identify(t) for t in tokens]
        for token, tokens in data.items()
    }


def to_adj_list(data: dict) -> list:
    global next_id  # Total number of nodes.
    return [
        data.get(i, [])
        for i in range(next_id)
    ]


def rev_adj_list(adj: list) -> list:
    # Reverses an adjacency list.
    rev_adj = [[] for _ in adj]  # Same number of nodes.

    for node, children in enumerate(adj):
        for child in children:
            # Child now points towards parent.
            rev_adj[child].append(node)

    return rev_adj


def calc_indeg(adj: list) -> list:
    # Calculate the in-degree for every node.
    indeg = [0] * len(adj)

    for children in adj:
        for child in children:
            indeg[child] += 1

    return indeg


def maxcon(adj: list) -> int:
    # Simulates build on adj. list and returns maximum concurrency.
    global revmapp  # To translate index to name for debugging purposes.
    rev = rev_adj_list(adj)
    indeg = calc_indeg(rev)
    nodes = [i for i, deg in enumerate(indeg) if deg == 0]
    assert nodes, "No source nodes found"
    built = set()

    concur = 0
    while nodes and len(built) != len(rev):
        # We can build all the nodes at this level.
        concur = max(len(nodes), concur)

        # Reduce in-degree of target nodes.
        # print(f'Building {len(nodes)} packages')
        nextnodes = []  # Keep track of next nodes to build.
        for node in nodes:

            # Ignore ones we've already built.
            if node in built:
                continue

            # print(f'\tBuilding {revmapp[node]}')

            children = rev[node]
            for child in children:
                indeg[child] -= 1
                if indeg[child] == 0:
                    nextnodes.append(child)

        # Add nodes to built set.
        for node in nodes:
            built.add(node)

        # Go onto the next iteration.
        nodes = nextnodes

    assert len(built) == len(rev), "Impossible to resolve dependencies"
    return concur


edges = read_input()
edges = remove_non_jb(edges)  # Remove nodes outside of 'jailbreak' subtree.
edges = deep_identify(edges)  # Replace string identifiers with integer ones.
edges = to_adj_list(edges)  # Convert to an adjacency list.

a = len(edges) - 1
print('Number of Dependencies:', a)

b = maxcon(edges)
print('Maximum Concurrency:', b)
