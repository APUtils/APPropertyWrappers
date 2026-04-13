//
//  Default.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 13.04.26.
//  Copyright © 2026 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

/// Property wrapper with default value
@propertyWrapper
open class Default<V: Codable>: Codable {
    
    private var isAdjusted: Bool
    private var storage: V
    
    open var wrappedValue: V {
        get {
            storage
        }
        set {
            storage = newValue
            isAdjusted = true
        }
    }
    
    /// Returns value if it was ever adjsuted. Otherwise, returns `nil`.
    open var adjusted: V? {
        isAdjusted ? storage : nil
    }
    
    // ******************************* MARK: - Initialization and Setup
    
    public init(
        defaultValue: V,
        file: String = #file,
        function: String = #function,
        line: UInt = #line
    ) {
        self.isAdjusted = false
        self.storage = defaultValue
    }
}

// ******************************* MARK: - Convenience Inits

public extension Default where V: ExpressibleByNilLiteral {
    convenience init() {
        self.init(defaultValue: nil)
    }
}

public extension Default where V: ExpressibleByArrayLiteral {
    convenience init() {
        self.init(defaultValue: [])
    }
}

public extension Default where V: ExpressibleByDictionaryLiteral {
    convenience init() {
        self.init(defaultValue: [:])
    }
}
