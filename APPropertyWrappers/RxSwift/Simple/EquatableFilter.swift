//
//  EquatableFilter.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

/// Property wrapper that prevent value set if it's equal to an existing one.
/// - Tag: EquatableFilter
@propertyWrapper
open class EquatableFilter<V: Equatable> {
    
    public typealias Compare = (V, V) -> Bool
    
    @BehaviorRelayProjected fileprivate(set) var storage: V
    fileprivate let compare: Compare?
    
    open var wrappedValue: V {
        get { storage }
        set {
            if let compare = compare {
                if !compare(storage, newValue) {
                    storage = newValue
                }
            } else {
                if storage != newValue {
                    storage = newValue
                }
            }
        }
    }
    
    public init(wrappedValue: V, compare: Compare? = nil) {
        storage = wrappedValue
        self.compare = compare
    }
}

// ******************************* MARK: - ObservableObserverType

extension EquatableFilter: ObservableObserverType {
    
    public typealias Element = V
    
    public func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        $storage.subscribe(observer)
    }
    
    public func on(_ event: Event<V>) {
        switch event {
        case .next(let element): wrappedValue = element
        default: return
        }
    }
}
