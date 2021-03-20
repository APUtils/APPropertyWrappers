//
//  BehaviorRelayProjected.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay

/// Property that projects value as `BehaviorRelay`.
/// Allowed internal access level: get + set.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: BehaviorRelayProjected
@propertyWrapper
public final class BehaviorRelayProjected<V> {
    
    // swiftlint:disable:next behavior_relay_backed
    public let projectedValue: BehaviorRelay<V>
    
    public var wrappedValue: V {
        get {
            projectedValue.value
        }
        set {
            projectedValue.accept(newValue)
        }
    }
    
    public init(wrappedValue: V) {
        projectedValue = BehaviorRelay(value: wrappedValue)
    }
    
    public init(projectedValue: BehaviorRelay<V>) {
        self.projectedValue = projectedValue
    }
}

// ******************************* MARK: - Equatable

extension BehaviorRelayProjected: Equatable where V: Equatable {
    public static func == (lhs: BehaviorRelayProjected<V>, rhs: BehaviorRelayProjected<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

// ******************************* MARK: - Codable

extension BehaviorRelayProjected: Codable where V: Codable {
    
    public convenience init(from decoder: Decoder) throws {
        let value = try V(from: decoder)
        self.init(wrappedValue: value)
    }
    
    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}
