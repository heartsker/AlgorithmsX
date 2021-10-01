import Foundation

public struct GraphVertex: Hashable, Comparable {
	public static func < (lhs: GraphVertex, rhs: GraphVertex) -> Bool {
		lhs.id < rhs.id
	}

	public static func == (lhs: GraphVertex, rhs: GraphVertex) -> Bool {
		lhs.id == rhs.id
	}

	let id: Int
}

public struct GraphEdge: Hashable, Comparable {
	public static func < (lhs: GraphEdge, rhs: GraphEdge) -> Bool {
		lhs.weight < rhs.weight
	}

	public static func == (lhs: GraphEdge, rhs: GraphEdge) -> Bool {
		lhs.weight == rhs.weight
	}

	let from: GraphVertex
	let to: GraphVertex
	let weight: Int

	init(from: Int, to: Int, weight: Int) {
		self.from = GraphVertex(id: from)
		self.to = GraphVertex(id: to)
		self.weight = weight
	}
}

public struct Graph {
	var edgesList: [GraphEdge]

	@inline(__always) public var countEdges: Int {
		edgesList.count
	}

	public init(edges: [GraphEdge]) {
		edgesList = edges
	}

	lazy var vertexes: [GraphVertex] = {
		var list = Set<GraphVertex>()
		for edge in edgesList {
			list.insert(edge.from)
		}
		return Array(list).sorted()
	}()

	lazy var adjecencyList: [GraphVertex: [GraphEdge]] = {
		var list = [GraphVertex: [GraphEdge]]()
		for edge in edgesList {
			list[edge.from] = (list[edge.from] ?? []) + [edge]
		}
		return list
	}()
}

public class Dijkstra {

	private struct VertexDist: Hashable {
		var dist: Int
		let id: Int
	}

	@inline(__always) private var count: Int {
		vertexes.count
	}

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
