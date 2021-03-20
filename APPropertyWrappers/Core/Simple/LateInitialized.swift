//
//  LateInitialized.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 10/23/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation

/// Late initialized property. Must be assigned before accessed.
/// Allows to avoid force unwrapped access.
/// Might be used e.g. for viewModel.
@propertyWrapper
open class LateInitialized<V> {
    
    open var projectedValue: V?
    
    open var wrappedValue: V {
        get {
            guard let value = projectedValue else {
                fatalError("value has not yet been set!")
            }
            return value
        }
        set {
            projectedValue = newValue
        }
    }
    
    public init(projectedValue: V? = nil) {
        self.projectedValue = projectedValue
    }
}

// ******************************* MARK: - Equatable

extension LateInitialized: Equatable where V: Equatable {
    public static func == (lhs: LateInitialized<V>, rhs: LateInitialized<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
