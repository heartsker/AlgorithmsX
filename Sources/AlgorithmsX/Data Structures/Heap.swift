	/// Heap is a specialized tree-based data structure which is essentially an almost complete tree that satisfies the heap property: In a max heap, for any given node C, if P is a parent node of C, then the value of P is greater than or equal to the key of C. In a min heap, the key of P is less than or equal to the value of C.
	/// - Note: More information [here](https://en.wikipedia.org/wiki/Heap_(data_structure))
public struct Heap<T: Hashable> {
		/// The collection of heap's nodes.
	private var nodes = [T]()

		/// Hash mapping from nodes to indices in the `nodes` array.
	private var indices = [T: Int]()

		/// Determines how to compare two nodes in the heap.
		/// - Use:
		/// 	- `'>'` - for a max-heap.
		/// 	- `'<'` - for a min-heap.
		/// 	- Provide a comparing method if the heap is made of custom elements.
	private var compareCriteria: (T, T) -> Bool

		/// Creates an empty heap.
		/// - Parameter sort: determines whather this is a **min**-heap or **max**-heap.
		/// - For comparable data types:
		/// 	- `'<'` makes a **min**-heap.
		/// 	- `'>'` makes a **max**-heap.
		/// - Complexity: **O(1)**.
	public init(sort: @escaping (T, T) -> Bool) {
		compareCriteria = sort
	}

		/// Creates a heap from an array. The order of the array elements does not matter.
		/// - Parameters:
		///   - array: array of elements to form the heap.
		///   - sort: determines whather this is a **min**-heap or **max**-heap.
		/// - For comparable data types:
		///		- `'<'` makes a **min**-heap.
		/// 	- `'>'` makes a **max**-heap.
		/// - Complexity: **O(n)**.
	public init(array: [T], sort: @escaping (T, T) -> Bool) {
		compareCriteria = sort
		configureHeap(from: array)
	}

		/// Configures the max-heap or min-heap from an array, in a bottom-up manner.
		/// - Parameter array: array of elements to form the heap.
		/// - Complexity: **O(n)**.
	public mutating func configureHeap(from array: [T]) {
		nodes = array
		for index in nodes.indices {
			indices[nodes[index]] = index
		}

		for i in stride(from: (nodes.count/2 - 1), through: 0, by: -1) {
			shiftDown(from: i, until: nodes.count)
		}
	}

		/// Determines whether heap is empty or not.
	@inline(__always) public var isEmpty: Bool {
		nodes.isEmpty
	}

		/// Determines the count of elements in the heap.
	@inline(__always) public var count: Int {
		nodes.count
	}

		/// Accesses a node by its index.
	private subscript(index: Int) -> T {
		nodes[index]
	}

		/// Returns the index of the given element.
		/// - Parameters:
		///	  - node: The node to find the index of.
		/// - Complexity: Amortized constant.
	private func index(of node: T) -> Int? {
		indices[node]
	}

		/// Returns the **maximum** value in the heap *(for a max-heap)* or the **minimum** value _(for a min-heap)_.
		/// - Returns: The **maximum** value in the heap *(for a max-heap)* or the **minimum** value _(for a min-heap)_.
		/// - Complexity: **O(1)**.
	@inline(__always) public func peek() -> T? {
		nodes.first
	}

		/// Adds a new value to the heap.
		/// - Parameter value: Value to be inserted.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds.
		/// - Complexity: **O(log n)**.
	public mutating func insert(_ value: T) {
		nodes.append(value)
		indices[value] = nodes.count - 1
		shiftUp(nodes.count - 1)
	}

		/// Allows you to change an element.
		/// - Parameters:
		///   - i: The index of the element to be replaced.
		///   - value: The value to replace element to.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds. In a **max**-heap, the new element should be larger than the old one; in a **min**-heap it should be smaller.
		/// - Complexity: **O(log n)**.
	private mutating func replace(_ value: T, at index: Int) {
		guard index < nodes.count else {
			return
		}
		assert(compareCriteria(value, nodes[index]))
		set(value, at: index)
		shiftUp(index)
	}

		/// Allows you to change an element.
		/// - Parameters:
		///   - node: The index of the element to be replaced.
		///   - value: The value to replace element to.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds. In a **max**-heap, the new element should be larger than the old one; in a **min**-heap it should be smaller.
		/// - Complexity: **O(log n)**.
	public mutating func replace(node: T, with value: T) {
		guard let index = indices[node] else {
			return
		}
		replace(value, at: index)
	}

		/// Removes the root node from the heap. For a **max**-heap, this is the **maximum** value; for a **min**-heap it is the **minimum** value.
		/// - Returns: The removed element.
		/// - Complexity: **O(log n)**.
	@discardableResult public mutating func remove() -> T? {
		guard !nodes.isEmpty else {
			return nil
		}
		if nodes.count == 1 {
			return removeLast()
		} else {
			let value = nodes[0]
			set(removeLast()!, at: 0)
			shiftDown()
			return value
		}
	}

		/// Removes an arbitrary node from the heap.
		/// - Parameter index: The index of the node to be removed.
		/// - Returns: The removed node.
		/// - Note: You need to know the node's index.
		/// - Complexity: **O(log n)**.
	@discardableResult private mutating func remove(at index: Int) -> T? {
		guard index < nodes.count else {
			return nil
		}

		let size = nodes.count - 1
		if index != size {
			swapAt(index, size)
			shiftDown(from: index, until: size)
			shiftUp(index)
		}
		return removeLast()
	}

		/// Removes an arbitrary node from the heap.
		/// - Parameter node: The node to be removed.
		/// - Complexity: **O(log n)**.
	public mutating func remove(node: T) {
		guard let index = indices[node] else {
			return
		}
		remove(at: index)
	}

		/// Removes all node from the heap.
		/// - Complexity: **O(n)**.
	public mutating func removeAll() {
		nodes.removeAll()
		indices.removeAll()
	}

		/// Removes the last node from the heap.
		/// - Complexity: **O(1)**.
	public mutating func removeLast() -> T? {
		guard let value = nodes.last else {
			return nil
		}
		indices[value] = nil
		return nodes.removeLast()
	}

		/// Takes a child node and looks at its parents. If a parent is not larger (**max**-heap) or not smaller (**min**-heap) than the child, we exchange them.
		/// - Parameter index: The index of node to be checked.
		/// - Complexity: **O(log n)**.
	private mutating func shiftUp(_ index: Int) {
		var childIndex = index
		let child = nodes[childIndex]
		var parentIndex = self.parentIndex(of: childIndex)

		while childIndex > 0 && compareCriteria(child, nodes[parentIndex]) {
			set(nodes[parentIndex], at: childIndex)
			childIndex = parentIndex
			parentIndex = self.parentIndex(of: childIndex)
		}

		set(child, at: childIndex)
	}

		/// Looks at a parent node and makes sure it is still larger (**max**-heap) or smaller (**min**-heap) than its childeren.
		/// - Parameters:
		///   - index: The index of node to be checked.
		///   - endIndex: The index of the node to stop at.
		/// - Complexity: **O(log n)**.
	private mutating func shiftDown(from index: Int, until endIndex: Int) {
		var parentIndex = index

		while true {
			let leftChildIndex = self.leftChildIndex(of: parentIndex)
			let rightChildIndex = leftChildIndex + 1

			var first = parentIndex
			if leftChildIndex < endIndex && compareCriteria(nodes[leftChildIndex], nodes[first]) {
				first = leftChildIndex
			}
			if rightChildIndex < endIndex && compareCriteria(nodes[rightChildIndex], nodes[first]) {
				first = rightChildIndex
			}
			if first == parentIndex { return }

			swapAt(parentIndex, first)
			parentIndex = first
		}
	}

		/// Looks at a parent node and makes sure it is still larger (**max**-heap) or smaller (**min**-heap) than its childeren.
		/// - Parameters:
		///   - index: The index of node to be checked.
		/// - Complexity: **O(log n)**.
	private mutating func shiftDown(_ index: Int = 0) {
		shiftDown(from: index, until: nodes.count)
	}

		/// Replaces the node in the heap and updates the indices hash.
		/// - Parameters:
		///   - newValue: The value for node to be set to.
		///	  - index: The index of the node to be set.
	private mutating func set(_ newValue: T, at index: Int) {
		indices[nodes[index]] = nil
		nodes[index] = newValue
		indices[newValue] = index
	}

		/// Swap two elements in the heap and update the indices hash.
		/// - Parameters:
		///   - i: The index of the first node.
		///   - j: The index of the second node.
		/// - Complexity: **O(1)**.
	private mutating func swapAt(_ i: Int, _ j: Int) {
		nodes.swapAt(i, j)
		indices[nodes[i]] = i
		indices[nodes[j]] = j
	}

		/// Returns the index of the parent of the element at index `index`.
		/// - Parameter index: The index of the element.
		/// - Returns: The index of the parent of the element at index i.
		/// - Note: The element at index 0 is the root of the tree and has no parent.
		/// - Complexity: **O(1)**.
	@inline(__always) private func parentIndex(of index: Int) -> Int {
		(index - 1) / 2
	}

		/// Returns the index of the left child of the element at index `index`.
		/// - Parameter index: The index of the element.
		/// - Returns: The index of the left child of the element at index `index`.
		/// - Note: This index can be greater than the heap size, in which case there is no left child.
		/// - Complexity: **O(1)**.
	@inline(__always) private func leftChildIndex(of index: Int) -> Int {
		2 * index + 1
	}

		/// Returns the index of the right child of the element at index `index`.
		/// - Parameter index: The index of the element.
		/// - Returns: The index of the left child of the element at index `index`.
		/// - Note: This index can be greater than the heap size, in which case there is no right child.
		/// - Complexity: **O(1)**.
	@inline(__always) private func rightChildIndex(of index: Int) -> Int {
		2 * index + 2
	}
}
