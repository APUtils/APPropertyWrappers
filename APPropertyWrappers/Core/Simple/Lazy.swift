//
//  Lazy.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 1/29/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation

@propertyWrapper
open class Lazy<V> {
    
    private var storedValue: V?
    
    open var projectedValue: () -> V {
        didSet {
            storedValue = nil
        }
    }
    
    open var wrappedValue: V {
        get {
            if let storedValue = storedValue {
                return storedValue
            } else {
                let value = projectedValue()
                storedValue = value
                return value
            }
        }
        set {
            storedValue = newValue
        }
    }
    
    public init(projectedValue: @autoclosure @escaping () -> V) {
        self.projectedValue = projectedValue
    }
}

// ******************************* MARK: - Equatable

extension Lazy: Equatable where V: Equatable {
    public static func == (lhs: Lazy<V>, rhs: Lazy<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
