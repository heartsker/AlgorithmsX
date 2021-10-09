# Dijkstra algorithm
Dijkstra's algorithm is an algorithm for finding the shortest paths between nodes in a graph, which may represent, for example, road networks.
See more information [here](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)

## Algorithm description

1. Assume that the distances to all vertexes from `start` is `INF` *(just a very big number, probably greater than length of any possible path in graph)*.
2. Distance from `start` to `start` is 0.
3. Choose the vertex *(which has not been choosen yet)* with the least distance from the `start`. Let us call it `best`. First iteration `best` = `start`.
4. Try to **relaxate** all the adjecent edges of `best`. Relaxation is a process of minimizing distances to adjecent vertexes if it is possible. That is possible to relax edge `e` if `distance[e.to] > distance[e.from] + e.weight`. In this case new distance will be `distance[e.to] = distance[e.from] + e.weight`.
5. If edge `e` was successfully relaxated, note what edge `e` is beneficial for the vertex `e.to`.
6. Mark the `best` as choosen.
7. Repeat points 3 - 6 `n` times, where `n` is the number of vertexes in the graph. There is rigorous proof that this process of relaxation will find the correct answer by only one relaxation for each vertex.
