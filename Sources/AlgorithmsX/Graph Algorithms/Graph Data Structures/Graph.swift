	/// Graph is a structure amounting to a set of objects (vertexes) in which some pairs of the objects are in some sense "related" (connected by edges).
	/// - Note: More information [here](https://en.wikipedia.org/wiki/Graph_(discrete_mathematics))
public struct Graph {
		/// The list of all edges of the graph.
	var edgesList: [GraphEdge]

		/// The number of edges in the graph.
	@inline(__always) public var countEdges: Int {
		edgesList.count
	}

		/// Creates a new graph by its edges.
		/// - Parameter edges: edges of the graph.
	public init(edges: [GraphEdge]) {
		edgesList = edges
	}

		/// The list of all vertexes of the graph.
	lazy var vertexes: [GraphVertex] = {
		var list = Set<GraphVertex>()
		for edge in edgesList {
			list.insert(edge.from)
		}
		return Array(list).sorted()
	}()

		/// The dictionary of ajecent edges for all vertexes.
	lazy var adjecencyList: [GraphVertex: [GraphEdge]] = {
		var list = [GraphVertex: [GraphEdge]]()
		for edge in edgesList {
			list[edge.from] = (list[edge.from] ?? []) + [edge]
		}
		return list
	}()
}
