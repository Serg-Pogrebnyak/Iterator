import UIKit

enum IteratorType {
    case defaultIterator
    case customIterator
}

indirect enum MyNode<T> {
    case value(element: T, next: MyNode)
    case end
    
    func get() -> (el: T, next: MyNode<T>)? {
        switch self {
        case .value(let el, let next):
            return (el, next)
        case .end:
            return nil
        }
    }
}

struct MyCustomList<T> {
    var head: MyNode<T>
    var iterator: IteratorType
    
    init(_ head: MyNode<T>, _ iterator: IteratorType = .defaultIterator) {
        self.head = head
        self.iterator = iterator
    }
}

extension MyCustomList: Sequence {
    func makeIterator() -> MyCustomListIterator<T> {
        switch self.iterator {
        case .defaultIterator:
            return MyCustomListIterator.init(current: head)
        case .customIterator:
            return MyCustomListThroughOneIterator.init(current: head)
        }
    }
}

class MyCustomListIterator<T>: IteratorProtocol {
    var current: MyNode<T>
    
    init(current: MyNode<T>) {
        self.current = current
    }

    func next() -> T? {
        if let result = current.get() {
            current = result.next
            return result.el
        } else {
            return nil
        }
    }
}

class MyCustomListThroughOneIterator<T>: MyCustomListIterator<T> {
    override func next() -> T? {
        if let result = current.get()?.next.get() {
            current = result.next
            return result.el
        } else {
            return nil
        }
    }
}

let node4 = MyNode.value(element: 20, next: .end)
let node3 = MyNode.value(element: 5, next: node4)
let node2 = MyNode.value(element: 7, next: node3)
let node1 = MyNode.value(element: 1, next: node2)

let myList = MyCustomList.init(node1, IteratorType.customIterator)

for i in myList {
    print(i)
}

