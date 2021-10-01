import XCTest
@testable import AlgorithmsX

final class DijkstraTests: XCTestCase {

	func test() {
		let edge01 = GraphEdge(from: 0, to: 1, weight: 1)
		let edge10 = GraphEdge(from: 1, to: 0, weight: 4)
		let edge12 = GraphEdge(from: 1, to: 2, weight: 1)
		let edge21 = GraphEdge(from: 2, to: 1, weight: 1)
		let edge02 = GraphEdge(from: 0, to: 2, weight: 2)
		let edge20 = GraphEdge(from: 2, to: 0, weight: 2)

		let edges = [
			edge01,
			edge10,
			edge12,
			edge21,
			edge02,
			edge20
		]

		let graph = Graph(edges: edges)

		let dijkstra = Dijkstra(graph: graph)

		let path = dijkstra.shortestPath(start: GraphVertex(id: 1), finish: GraphVertex(id: 0))

		XCTAssertEqual(path, [edge12, edge20], "Incorrect path")

	}

}
