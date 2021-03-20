//
//  EquatableFilter_ObservableProjected.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxSwift

/// Property that projects value as `Observable`. This one doesn't trigger events for updates with equal objects.
/// Allowed internal access level: get.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: EquatableFilter_ObservableProjected
@propertyWrapper
final class EquatableFilter_ObservableProjected<V: Equatable> {
    
    @EquatableFilter fileprivate var filter: V
    @BehaviorRelayProjected fileprivate var storage: V
    fileprivate let disposeBag = DisposeBag()
    
    var projectedValue: Observable<V> { $storage.asObservable() }
    
    var wrappedValue: V {
        get {
            storage
        }
        set {
            filter = newValue
        }
    }
    
    init(wrappedValue: V, compare: EquatableFilter<V>.Compare? = nil) {
        storage = wrappedValue
        _filter = EquatableFilter(wrappedValue: _storage.wrappedValue, compare: compare)
        
        setup()
    }
    
    fileprivate func setup() {
        _filter
            // Since filter emits the current value immediately we need to skip the first one
            .skip(1)
            .bind(to: $storage)
            .disposed(by: disposeBag)
    }
}

// ******************************* MARK: - Equatable

extension EquatableFilter_ObservableProjected: Equatable where V: Equatable {
    static func == (lhs: EquatableFilter_ObservableProjected<V>, rhs: EquatableFilter_ObservableProjected<V>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}

// ******************************* MARK: - Codable

extension EquatableFilter_ObservableProjected: Codable where V: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let value = try V(from: decoder)
        self.init(wrappedValue: value)
    }
    
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

// ******************************* MARK: - ObservableObserverType

extension EquatableFilter_ObservableProjected: ObservableObserverType {
    
    typealias Element = V
    
    func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        $storage.subscribe(observer)
    }
    
    func on(_ event: Event<V>) {
        switch event {
        case .next(let element): wrappedValue = element
        default: return
        }
    }
}
