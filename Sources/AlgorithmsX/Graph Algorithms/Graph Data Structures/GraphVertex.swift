	/// Structure to store information about vertex in the graph and represent significant data for graph algorithms.
public struct GraphVertex: Hashable, Comparable {
	public static func < (lhs: GraphVertex, rhs: GraphVertex) -> Bool {
		lhs.id < rhs.id
	}

	public static func == (lhs: GraphVertex, rhs: GraphVertex) -> Bool {
		lhs.id == rhs.id
	}

		/// The identificator of the vertex. Different vertexes in same graph have different ids.
	let id: Int
}
