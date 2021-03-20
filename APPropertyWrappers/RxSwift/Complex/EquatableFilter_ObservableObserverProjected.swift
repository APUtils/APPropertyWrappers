//
//  EquatableFilter_ObservableObserverProjected.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

/// Property that projects value as `ObservableObserver`. This one doesn't trigger events for updates with equal objects.
/// Allowed internal access level: get + set.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: EquatableFilter_ObservableObserverProjected
@propertyWrapper
open class EquatableFilter_ObservableObserverProjected<V: Equatable> {
    
    @EquatableFilter fileprivate var filter: V
    @BehaviorRelayProjected fileprivate var storage: V
    fileprivate let disposeBag = DisposeBag()
    
    open var projectedValue: ObservableObserver<V> {
        ObservableObserver(observer: _filter.asObserver(),
                           observable: $storage.asObservable())
    }
    
    open var wrappedValue: V {
        get {
            storage
        }
        set {
            filter = newValue
        }
    }
    
    public init(wrappedValue value: V, compare: EquatableFilter<V>.Compare? = nil) {
        storage = value
        _filter = EquatableFilter(wrappedValue: _storage.wrappedValue, compare: compare)
        
        setup()
    }
    
    public init(storage: BehaviorRelay<V>, compare: EquatableFilter<V>.Compare? = nil) {
        _storage = BehaviorRelayProjected(projectedValue: storage)
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
