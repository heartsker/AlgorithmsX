	/// This class realizes the Dijkstra algorithm.
	/// Dijkstra algorithm is an algorithm for finding the shortest paths between vertexes in a graph.
	/// - Note: More information [here](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)
public class Dijkstra {

		/// Struct to store distance from start vertex to another and it's id.
	private struct VertexDist: Hashable {
		var dist: Int
		let id: Int
	}
		/// The number of vertexes in the graph.
	@inline(__always) private var count: Int {
		vertexes.count
	}

		/// Just a very big number which is probably greater than the longest possible path in the graph.
	private let INF = 1_000_000_000_000_000_000

	private var graph: Graph
	private let vertexes: [GraphVertex]!
	private let adjecencyList: [GraphVertex: [GraphEdge]]
	private var heap: Heap<VertexDist>!

	public init(graph: Graph) {
		self.graph = graph
		vertexes = self.graph.vertexes
		adjecencyList = self.graph.adjecencyList
	}

		/// Defines the most beneficial edge to reach the start vertex.
		/// - Parameter start: the vertex to find distances of paths to.
		/// - Returns: The list of beneficial edges.
	private func dijkstra(start: GraphVertex) -> [GraphEdge] {

		var from = Array(repeating: GraphEdge(from: -1, to: -1, weight: -1), count: count)
		var distances: [VertexDist] = []

		for i in 0 ..< count {
			distances.append(VertexDist(dist: INF, id: i))
		}

		distances[start.id].dist = 0

		heap = Heap() { e1, e2 in
			e1.dist < e2.dist
		}

		heap.configureHeap(from: distances)

		while !heap.isEmpty {
			let best = heap.peek()!
			let id = best.id
			let dist = best.dist

			for edge in adjecencyList[vertexes[id]]! {
				let to = edge.to.id
				if distances[to].dist > dist + edge.weight {
					heap.replace(node: VertexDist(dist: distances[to].dist, id: to),
								 with: VertexDist(dist: dist + edge.weight, id: to))
					distances[to].dist = dist + edge.weight
					from[to] = edge
				}
			}
			heap.remove()
		}

		return from
	}

		/// Finds the shortest path between two given vertexes.
		/// - Parameters:
		///   - start: the start vertex.
		///   - finish: the finish vertex.
		/// - Returns: List of edges of the shortest path from `start` vertex to `finish` vertex.
	public func shortestPath(start: GraphVertex, finish: GraphVertex) -> [GraphEdge] {
		let from = dijkstra(start: start)

		var path = [GraphEdge]()
		var current = finish.id

		while from[current].from.id != -1 {
			path.append(from[current])
			current = from[current].from.id
		}

		return path.reversed()
	}
}
