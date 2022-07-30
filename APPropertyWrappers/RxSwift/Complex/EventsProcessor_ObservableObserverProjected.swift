//
//  EventsProcessor_ObservableObserverProjected.swift
//  Pods
//
//  Created by Anton Plebanovich on 30.07.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import RxRelay
import RxSwift
import RxUtils

/// Property that projects value as `ObservableObserver`.
/// It is additionally protected with `EventProcessor` at the start of value assign to prevent reentrancy anomaly.
/// Allowed internal access level: get + set.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: EventsProcessor_ObservableObserverProjected
@propertyWrapper
public final class EventsProcessor_ObservableObserverProjected<V> {
    
    fileprivate let eventProcessor = EventsProcessor<V>()
    @BehaviorRelayProjected fileprivate var storage: V
    fileprivate let disposeBag = DisposeBag()
    
    public var projectedValue: ObservableObserver<V> {
        ObservableObserver(observer: eventProcessor.asObserver(),
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
    
    public init(wrappedValue value: V) {
        storage = value
        
        setup()
    }
    
    public init(storage: BehaviorRelay<V>) {
        _storage = BehaviorRelayProjected(projectedValue: storage)
        
        setup()
    }
    
    fileprivate func setup() {
        eventProcessor
            .bind(to: $storage)
            .disposed(by: disposeBag)
    }
}
