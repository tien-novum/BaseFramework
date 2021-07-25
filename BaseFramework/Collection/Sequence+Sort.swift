//
//  Sequence+Sort.swift
//  BaseFramework
//
//  Created by Lai Trung Tien on 25/07/2021.
//

import Foundation

public struct SortDescriptor<Value> {
    var comparator: (Value, Value) -> ComparisonResult
}

extension SortDescriptor {
    public static func keyPath<T: Comparable>(_ keyPath: KeyPath<Value, T>) -> Self {
        Self { rootA, rootB in
            let valueA = rootA[keyPath: keyPath]
            let valueB = rootB[keyPath: keyPath]
            
            guard valueA != valueB else {
                return .orderedSame
            }
            
            return valueA < valueB ? .orderedAscending : .orderedDescending
        }
    }
}

public enum SortOrder {
    case ascending
    case descending
}

extension Sequence {
    public func sorted(using descriptors: SortDescriptor<Element>..., order: SortOrder) -> [Element] {
        sorted { valueA, valueB in
            for descriptor in descriptors {
                let result = descriptor.comparator(valueA, valueB)
                switch result {
                case .orderedSame:
                    break
                case .orderedAscending:
                    return order == .ascending
                case .orderedDescending:
                    return order == .descending
                }
            }
            
            return false
        }
    }
}
