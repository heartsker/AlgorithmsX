	/// Heap is a specialized tree-based data structure which is essentially an almost complete tree that satisfies the heap property: In a max heap, for any given node C, if P is a parent node of C, then the value of P is greater than or equal to the key of C. In a min heap, the key of P is less than or equal to the value of C.
	/// - Note: more information [here](https://en.wikipedia.org/wiki/Heap_(data_structure) )
public struct Heap<T> {

		/// The collection of heap's nodes
	private var nodes = [T]()

		/// Determines how to compare two nodes in the heap.
		/// - Use:
		/// 	- `'>'` - for a max-heap.
		/// 	- `'<'` - for a min-heap.
		/// 	- Provide a comparing method if the heap is made of custom elements.
	private var compareCriteria: (T, T) -> Bool

		/// Creates an empty heap
		/// - Parameter sort: determines whather this is a **min**-heap or **max**-heap.
		/// - For comparable data types:
		/// 	- `'<'` makes a **min**-heap.
		/// 	- `'>'` makes a **max**-heap.
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
	public init(array: [T], sort: @escaping (T, T) -> Bool) {
		compareCriteria = sort
		configureHeap(from: array)
	}

		/// Configures the max-heap or min-heap from an array, in a bottom-up manner.
		/// - Parameter array: array of elements to form the heap.
		/// - Complexity: **O(n)**.
	private mutating func configureHeap(from array: [T]) {
		nodes = array
		for i in stride(from: (nodes.count / 2 - 1), through: 0, by: -1) {
			shiftDown(i)
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

		/// Returns the index of the parent of the element at index `i`.
		/// - Parameter i: The index of the element.
		/// - Returns: The index of the parent of the element at index i.
		/// - Note: The element at index 0 is the root of the tree and has no parent.
	@inline(__always) private func parentIndex(ofIndex i: Int) -> Int {
		(i - 1) / 2
	}

		/// Returns the index of the left child of the element at index `i`.
		/// - Parameter i: The index of the element.
		/// - Returns: The index of the left child of the element at index i.
		/// - Note: This index can be greater than the heap size, in which case there is no left child.
	@inline(__always) private func leftChildIndex(ofIndex i: Int) -> Int {
		2 * i + 1
	}

		/// Returns the index of the right child of the element at index i.
		/// - Parameter i: The index of the element.
		/// - Returns: The index of the left child of the element at index i.
		/// - Note: This index can be greater than the heap size, in which case there is no right child.
	@inline(__always) private func rightChildIndex(ofIndex i: Int) -> Int {
		return 2 * i + 2
	}

		/// Returns the **maximum** value in the heap *(for a max-heap)* or the **minimum** value _(for a min-heap)_.
		/// - Returns: The **maximum** value in the heap *(for a max-heap)* or the **minimum** value _(for a min-heap)_.
	@inline(__always) public func peek() -> T? {
		nodes.first
	}

		/// Adds a new value to the heap.
		/// - Parameter value: Value to be inserted.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds.
		/// - Complexity: **O(log n)**.
	public mutating func insert(_ value: T) {
		nodes.append(value)
		shiftUp(nodes.count - 1)
	}

		/// Adds a sequence of values to the heap.
		/// - Parameter sequence: Sequence to be inserted.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds.
		/// - Complexity: **O(m • log n)**, where `m` is the lenght of the sequence.
	public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
		for value in sequence {
			insert(value)
		}
	}

		/// Allows you to change an element.
		/// - Parameters:
		///   - i: The index of the element to be replaced.
		///   - value: The value to replace element to.
		/// - Note: This reorders the heap so that the **max**-heap or **min**-heap property still holds.
	public mutating func replace(index i: Int, value: T) {
		guard i < nodes.count else {
			return
		}

		remove(at: i)
		insert(value)
	}

		/// Removes the root node from the heap. For a **max**-heap, this is the **maximum** value; for a **min**-heap it is the **minimum** value.
		/// - Returns: removed element.
		/// - Complexity: **O(log n)**.
	@discardableResult public mutating func remove() -> T? {
		guard !nodes.isEmpty else {
			return nil
		}

		if nodes.count == 1 {
			return nodes.removeLast()
		} else {
			let value = nodes[0]
			nodes[0] = nodes.removeLast()
			shiftDown(0)
			return value
		}
	}

		/// Removes an arbitrary node from the heap.
		/// - Parameter index: The index of the element to be removed.
		/// - Returns: The removed element.
		/// - Note: You need to know the node's index.
		/// - Complexity: **O(log n)**
	@discardableResult public mutating func remove(at index: Int) -> T? {
		guard index < nodes.count else {
			return nil
		}

		let size = nodes.count - 1
		if index != size {
			nodes.swapAt(index, size)
			shiftDown(from: index, until: size)
			shiftUp(index)
		}
		return nodes.removeLast()
	}

		/// Takes a child node and looks at its parents. If a parent is not larger (**max**-heap) or not smaller (**min**-heap) than the child, we exchange them.
		/// - Parameter index: The index of node to be checked.
	private mutating func shiftUp(_ index: Int) {
		var childIndex = index
		let child = nodes[childIndex]
		var parentIndex = self.parentIndex(ofIndex: childIndex)

		while childIndex > 0 && compareCriteria(child, nodes[parentIndex]) {
			nodes[childIndex] = nodes[parentIndex]
			childIndex = parentIndex
			parentIndex = self.parentIndex(ofIndex: childIndex)
		}

		nodes[childIndex] = child
	}

		/// Looks at a parent node and makes sure it is still larger (**max**-heap) or smaller (**min**-heap) than its childeren.
		/// - Parameters:
		///   - index: The index of node to be checked.
		///   - endIndex: The index of the node to stop at.
	private mutating func shiftDown(from index: Int, until endIndex: Int) {
		let leftChildIndex = self.leftChildIndex(ofIndex: index)
		let rightChildIndex = leftChildIndex + 1
		var first = index
		if leftChildIndex < endIndex && compareCriteria(nodes[leftChildIndex], nodes[first]) {
			first = leftChildIndex
		}
		if rightChildIndex < endIndex && compareCriteria(nodes[rightChildIndex], nodes[first]) {
			first = rightChildIndex
		}
		if first == index { return }

		nodes.swapAt(index, first)
		shiftDown(from: first, until: endIndex)
	}

		/// Looks at a parent node and makes sure it is still larger (**max**-heap) or smaller (**min**-heap) than its childeren.
		/// - Parameters:
		///   - index: The index of node to be checked.
	private mutating func shiftDown(_ index: Int) {
		shiftDown(from: index, until: nodes.count)
	}
}

extension Heap where T: Equatable {

		/// Get the index of a node in the heap.
		/// - Parameter node: The node to be found.
		/// - Returns: The index of a node in the heap.
		/// - Complexity: **O(n)**
	public func index(of node: T) -> Int? {
		nodes.firstIndex(where: { $0 == node })
	}

		/// Removes the first occurrence of a node from the heap.
		/// - Parameter node: The node to be removed.
		/// - Returns: The removed node.
		/// - Complexity: **O(n)**
	@discardableResult public mutating func remove(node: T) -> T? {
		guard let index = index(of: node) else {
			return nil
		}
		return remove(at: index)
	}
}
