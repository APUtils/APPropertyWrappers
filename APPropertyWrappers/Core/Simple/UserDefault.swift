//
//  UserDefault.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 12/13/19.
//  Copyright © 2019 Anton Plebanovich. All rights reserved.
//

import Foundation
import RoutableLogger

/// Property wrapper that stores value as an object in UserDefaults.
@propertyWrapper
open class UserDefault<V> {
    
    private let userDefaults: UserDefaults
    private let key: String
    @Lazy private var defferedDefaultValue: V
    
    /// Storage that is used to prevent continuous object decode and so to speedup property access.
    @Lazy private var storage: V
    
    open var wrappedValue: V {
        get {
            storage
        }
        set {
            storage = newValue
            if (newValue as AnyObject) is NSNull {
                userDefaults.set(Data(), forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
    
    /// Removes object from the UserDefaults
    open func removeFromUserDefaults() {
        userDefaults.removeObject(forKey: key)
    }
    
    /// Resets preserved value to its default.
    open func reset() {
        removeFromUserDefaults()
        _storage.projectedValue = _defferedDefaultValue.projectedValue
    }
    
    public convenience init(suitName: String? = nil,
                            key: String,
                            defaultValue: V,
                            file: String = #file,
                            function: String = #function,
                            line: UInt = #line) {
        
        self.init(suitName: suitName, key: key, defferedDefaultValue: defaultValue, file: file, function: function, line: line)
    }
    
    public init(suitName: String? = nil,
                key: String,
                defferedDefaultValue: @escaping @autoclosure () -> V,
                file: String = #file,
                function: String = #function,
                line: UInt = #line) {
        
        GlobalFunctions.reportUserDefaultsDotKeyIfNeeded(key: key, file: file, function: function, line: line)
        
        let userDefaults: UserDefaults
        if let suitName = suitName {
            if let _userDefaults = UserDefaults(suiteName: suitName) {
                userDefaults = _userDefaults
            } else {
                RoutableLogger.logError("Unable to initialize user defaults", data: ["suitName": suitName])
                userDefaults = .standard
            }
        } else {
            userDefaults = .standard
        }
        self.userDefaults = userDefaults
        
        self.key = key
        self._defferedDefaultValue = Lazy(projectedValue: defferedDefaultValue())
        
        self._storage = Lazy(projectedValue: { () -> V in
            if let object = userDefaults.object(forKey: key) {
                if let value = object as? V {
                    return value
                } else if let data = object as? Data, data.isEmpty, let value = Optional<Any>.none as? V {
                    return value
                }
            }
            
            return defferedDefaultValue()
        }())
    }
}

// ******************************* MARK: - Convenience Inits

public extension UserDefault where V: ExpressibleByNilLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: nil)
    }
}

public extension UserDefault where V: ExpressibleByArrayLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [])
    }
}

public extension UserDefault where V: ExpressibleByDictionaryLiteral {
    convenience init(suitName: String? = nil, key: String) {
        self.init(suitName: suitName, key: key, defaultValue: [:])
    }
}
