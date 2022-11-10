//
//  Atomic.swift
//  Pods
//
//  Created by Anton Plebanovich on 10.11.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

@propertyWrapper
public struct Atomic<T> {
    
    fileprivate var value: T
    fileprivate var lock = os_unfair_lock_s()
    
    public init(wrappedValue value: T) {
        self.value = value
    }
    
    public var wrappedValue: T {
        mutating get {
            os_unfair_lock_lock(&lock); defer { os_unfair_lock_unlock(&lock) }
            return value
        }
        set {
            os_unfair_lock_lock(&lock); defer { os_unfair_lock_unlock(&lock) }
            value = newValue
        }
    }
}
