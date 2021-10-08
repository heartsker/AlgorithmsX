	/// Structure to store information about edge in the graph and represent significant data for graph algorithms.
public struct GraphEdge: Hashable, Comparable {
	public static func < (lhs: GraphEdge, rhs: GraphEdge) -> Bool {
		lhs.weight < rhs.weight
	}

	public static func == (lhs: GraphEdge, rhs: GraphEdge) -> Bool {
		lhs.weight == rhs.weight
	}

		/// The vertex there the edge starts.
	let from: GraphVertex
		/// The vertex there the edge ends.
	let to: GraphVertex
		/// The value of the edge. It could be weight, lenght, etc.
	let weight: Int

	init(from: Int, to: Int, weight: Int) {
		self.from = GraphVertex(id: from)
		self.to = GraphVertex(id: to)
		self.weight = weight
	}
}
