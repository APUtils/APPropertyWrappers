//
//  Lazy.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 1/29/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

#if SPM
import APExtensionsOptionalType
#else
import APExtensions
#endif

import Foundation

@propertyWrapper
open class Lazy<V> {
    
    fileprivate let lock = NSLock()
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
                lock.lock(); defer { lock.unlock() }
                
                // Second check because the first one was without lock for performance reasons
                if let storedValue = storedValue {
                    return storedValue
                } else {
                    let value = projectedValue()
                    storedValue = value
                    return value
                }
            }
        }
        set {
            storedValue = newValue
        }
    }
    
    public init(projectedValue: @escaping () -> V) {
        self.projectedValue = projectedValue
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

// ******************************* MARK: - Optional Value

extension Lazy where V: OptionalType {
    public convenience init(projectedValue: (() -> V.Wrapped?)?) {
        self.init(projectedValue: { projectedValue?() as! V })
    }
}
