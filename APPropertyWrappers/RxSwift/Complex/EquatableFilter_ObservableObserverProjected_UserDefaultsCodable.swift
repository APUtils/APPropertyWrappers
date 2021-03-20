//
//  EquatableFilter_ObservableObserverProjected_UserDefaultCodable.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxCocoa
import RxRelay
import RxSwift

/// Property that projects value as `ObservableObserver` and also saves value to the `UserDefaults`.
/// Allowed internal access level: get + set.
/// On instantiation it restores previously saved value or uses provided `defaultValue`.
/// It doesn't trigger events for updates with equal objects.
/// - note: It's a class and not a struct to prevent `Simultaneous accesses to 0xXXXXXXXXX, but modification requires exclusive access` crash.
/// - Tag: EquatableFilter_ObservableObserverProjected_UserDefaultCodable
@propertyWrapper
open class EquatableFilter_ObservableObserverProjected_UserDefaultCodable<V: Codable & Equatable> {
    
    @EquatableFilter fileprivate var filter: V
    @UserDefaultCodable fileprivate var userDefault: V
    @BehaviorRelayProjected fileprivate var storage: V
    
    open var projectedValue: ObservableObserver<V> {
        ObservableObserver(observer: _filter.asObserver(), observable: $storage.asObservable())
    }
    
    fileprivate let disposeBag = DisposeBag()
    
    open var wrappedValue: V {
        get {
            /// For some reason using `UserDefaults` as the source doesn't always work
            /// and causes crashes in unit tests. Might be sync issue.
            storage
        }
        set {
            filter = newValue
        }
    }
    
    public init(key: String, defaultValue: V, compare: EquatableFilter<V>.Compare? = nil) {
        _userDefault = UserDefaultCodable(key: key, defaultValue: defaultValue)
        storage = _userDefault.wrappedValue
        _filter = EquatableFilter(wrappedValue: _storage.wrappedValue, compare: compare)
        
        setup()
    }
    
    fileprivate func setup() {
        _filter
            // Since filter emits the current value immediately we need to skip the first one
            .skip(1)
            .bind(to: $storage)
            .disposed(by: disposeBag)
        
        projectedValue
            // Since BehaviorRelay emits the current value immediately we need to skip the first one
            .skip(1)
            .bind(to: _userDefault)
            .disposed(by: disposeBag)
    }
}

// ******************************* MARK: - Convenience Inits

extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByNilLiteral {
    convenience init(key: String, compare: EquatableFilter<V>.Compare? = nil) {
        self.init(key: key, defaultValue: nil, compare: compare)
    }
}

extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByArrayLiteral {
    convenience init(key: String, compare: EquatableFilter<V>.Compare? = nil) {
        self.init(key: key, defaultValue: [], compare: compare)
    }
}

extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByDictionaryLiteral {
    convenience init(key: String, compare: EquatableFilter<V>.Compare? = nil) {
        self.init(key: key, defaultValue: [:], compare: compare)
    }
}
