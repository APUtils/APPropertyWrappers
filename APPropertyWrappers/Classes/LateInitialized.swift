//
//  LateInitialized.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 10/23/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

/// Late initialized property. Must be assigned before accessed.
/// Allows to avoid force unwrapped access.
/// Might be used e.g. for viewModel.
@propertyWrapper
public struct LateInitialized<V> {
    
    private var storage: V?
    
    var wrappedValue: V {
        get {
            guard let value = storage else {
                fatalError("value has not yet been set!")
            }
            return value
        }
        set {
            storage = newValue
        }
    }
    
    init() {
        storage = nil
    }
}

// ******************************* MARK: - Equatable

extension LateInitialized: Equatable where V: Equatable {}
