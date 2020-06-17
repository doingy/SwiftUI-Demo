//: [Previous](@previous)

import Combine

check("empty") {
    Empty<Int, SampleError>()
}

check("Just") {
    Just("Hello SwiftUI")
}

check("Map") {
    [1, 2, 3].publisher.map { $0 * 2 }
}

check("Sequence") {
    Publishers.Sequence<[Int], Never>(sequence: [1, 2, 3])
}

check("Scan") {
    [1, 2, 3, 4, 5].publisher.scan(0, +)
}

check("Compact Map") {
    ["1", "2", "3", "cat", "5"].publisher.compactMap { Int($0) }
}

check("Flat Map 1") {
    [[1, 2, 3], ["a", "b", "c"]].publisher.flatMap { $0.publisher }
}

check("Flat Map 2") {
    ["A", "B", "C"].publisher.flatMap { letter in
        [1, 2, 3].publisher.map { "\(letter)\($0)" }
    }
}

check("Remove Duplicates") {
    ["S", "Sw", "Sw", "Sw", "Swi", "Swif", "Swift", "Swift", "Swif"].publisher.removeDuplicates()
}

//check("Fail") {
//    Fail<Int, SampleError>(error: .sampleError)
//}

//: [Next](@next)
