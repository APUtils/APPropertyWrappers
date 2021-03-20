//
//  ObservableProjected.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

/// Property that projects value as `Observable`.
/// Allowed internal access level: get.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: ObservableProjected
@propertyWrapper
final class ObservableProjected<V> {
    
    @BehaviorRelayProjected fileprivate var storage: V
    
    var projectedValue: Observable<V> { $storage.asObservable() }
    
    var wrappedValue: V {
        get {
            storage
        }
        set {
            storage = newValue
        }
    }
    
    init(wrappedValue: V) {
        storage = wrappedValue
    }
}

// ******************************* MARK: - Equatable

extension ObservableProjected: Equatable where V: Equatable {
    static func == (lhs: ObservableProjected<V>, rhs: ObservableProjected<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

// ******************************* MARK: - Codable

extension ObservableProjected: Codable where V: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let value = try V(from: decoder)
        self.init(wrappedValue: value)
    }
    
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

// ******************************* MARK: - ObservableObserverType

extension ObservableProjected: ObservableObserverType {
    
    typealias Element = V
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        $storage.subscribe(observer)
    }
    
    func on(_ event: Event<V>) {
        $storage.on(event)
    }
}
