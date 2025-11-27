#!/bin/python3

import sys

def print_graph(graph):
    print('graph Routes {')
    visited = []
    for location, adj in graph.items():
        visited.append(location)
        for loc, dist in adj:
            if loc in visited: continue
            print(f'  {location} -- {loc}[label="{dist}"]')
    print('}')
    exit(0)

def make_graph(content):
    graph = {}
    for line in content.split('\n'):
        tokens = line.split(' ')
        left = tokens[0]
        right = tokens[2]
        dist = int(tokens[4])
        if left in graph:
            graph[left].append((right, dist))
        else:
            graph[left] = [(right, dist)]
        if right in graph:
            graph[right].append((left, dist))
        else:
            graph[right] = [(left, dist)]
    return graph

def best_path(graph, start, visited, maximum=False):
    if len(visited) == len(graph): return 0
    best = 0 if maximum else sys.maxsize
    for loc, dist in graph[start]:
        if loc in visited: continue
        distance = dist + best_path(graph, loc, visited + [loc], maximum)
        if maximum:
            if distance > best:
                best = distance
        else:
            if distance < best:
                best = distance

    return best

def part_one(content):
    graph = make_graph(content)
    minimum = sys.maxsize
    for start in graph.keys():
        distance = best_path(graph, start, [start])
        if distance < minimum:
            minimum = distance
    return minimum

def part_two(content):
    graph = make_graph(content)
    maximum = 0
    for start in graph.keys():
        distance = best_path(graph, start, [start], maximum=True)
        if distance > maximum:
            maximum = distance
    return maximum

f = open('input.txt')
content = f.read().strip()
f.close()
print('Part one:', part_one(content))
print('Part two:', part_two(content))
