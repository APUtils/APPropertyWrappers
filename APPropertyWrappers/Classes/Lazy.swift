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
    
    open var lazyValue: () -> V {
        didSet {
            storedValue = nil
        }
    }
    
    open var wrappedValue: V {
        get {
            if let storedValue = storedValue {
                return storedValue
            } else {
                let value = lazyValue()
                storedValue = value
                return value
            }
        }
        set {
            storedValue = newValue
        }
    }
    
    public init(lazyValue: @autoclosure @escaping () -> V) {
        self.lazyValue = lazyValue
    }
}

// ******************************* MARK: - Equatable

extension Lazy: Equatable where V: Equatable {
    public static func == (lhs: Lazy<V>, rhs: Lazy<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
