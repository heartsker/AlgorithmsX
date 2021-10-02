# AlgorithmsX

## Algorithms

### [Graph algorighms](https://github.com/heartsker/AlgorithmsX/tree/main/Sources/AlgorithmsX/Graph%20Algorithms)

- [Dijkstra](https://github.com/heartsker/AlgorithmsX/blob/main/Sources/AlgorithmsX/Graph%20Algorithms/Dijkstra.swift) (since `1.0.0`)
	- Find the lenght of the shortest path from `start` vertex to all of the others.
	- Find the shortest path from `start` to `finish` vertexes.
	- Complexity: O(N • log M), where N - number of vertexes, M - number of edges.
	- The most efficient in sparce graphs *(where M significantly less N * N)*.

## [Data structures](https://github.com/heartsker/AlgorithmsX/tree/main/Sources/AlgorithmsX/Data%20Structures)

### Binary trees

- [Hashed heap](https://github.com/heartsker/AlgorithmsX/blob/main/Sources/AlgorithmsX/Data%20Structures/Heap.swift) (since `1.0.0`)
	- Heap is a specialized tree-based data structure which is essentially an almost complete tree that satisfies the heap property: In a max heap, for any given node C, if P is a parent node of C, then the value of P is greater than or equal to the key of C. In a min heap, the key of P is less than or equal to the value of C.
	- More information [here](https://en.wikipedia.org/wiki/Heap_(data_structure) )
