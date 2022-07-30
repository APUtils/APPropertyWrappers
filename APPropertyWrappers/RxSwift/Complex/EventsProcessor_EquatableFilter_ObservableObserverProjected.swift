//
//  EventsProcessor_EquatableFilter_ObservableObserverProjected.swift
//  Pods
//
//  Created by Anton Plebanovich on 30.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import RxRelay
import RxSwift
import RxUtils

/// Property that projects value as `ObservableObserver`. This one doesn't trigger events for updates with equal objects.
/// It is additionally protected with `EventProcessor` at the start of value assign to prevent reentrancy anomaly.
/// Allowed internal access level: get + set.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: EventsProcessor_EquatableFilter_ObservableObserverProjected
@propertyWrapper
public final class EventsProcessor_EquatableFilter_ObservableObserverProjected<V: Equatable> {
    
    fileprivate let eventProcessor = EventsProcessor<V>()
    @EquatableFilter fileprivate var filter: V
    @BehaviorRelayProjected fileprivate var storage: V
    fileprivate let disposeBag = DisposeBag()
    
    public var projectedValue: ObservableObserver<V> {
        ObservableObserver(observer: _filter.asObserver(),
                           observable: $storage.asObservable())
    }
    
    public var wrappedValue: V {
        get {
            storage
        }
        set {
            eventProcessor.addEvent(newValue)
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
        eventProcessor
            .bind(to: _filter)
            .disposed(by: disposeBag)
        
        _filter
        // Since filter emits the current value immediately we need to skip the first one
            .skip(1)
            .bind(to: $storage)
            .disposed(by: disposeBag)
    }
}
