//
//  EquatableFilter_ObservableObserverProjected_UserDefaultCodable.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

#if SPM
import APPropertyWrappers
#endif

import Foundation
import RxCocoa
import RxRelay
import RxSwift
import RxUtils

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
    
    public var preservedValue: V? {
        _userDefault.preservedValue
    }
    
    public var hasPreservedValue: Bool {
        _userDefault.hasPreservedValue
    }
    
    public init(key: String,
                defaultValue: V,
                compare: EquatableFilter<V>.Compare? = nil,
                file: String = #file,
                function: String = #function,
                line: UInt = #line) {
        
        _userDefault = UserDefaultCodable(key: key, defaultValue: defaultValue, file: file, function: function, line: line)
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
    
    /// Resets preserved value to its default by removing value from `UserDefaults`
    open func reset() {
        filter = _userDefault.defaultValue // Storage is updated if needed
        _userDefault.reset()
    }
}

// ******************************* MARK: - Convenience Inits

public extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByNilLiteral {
    convenience init(key: String,
                     compare: EquatableFilter<V>.Compare? = nil,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(key: key, defaultValue: nil, compare: compare, file: file, function: function, line: line)
    }
}

public extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByArrayLiteral {
    convenience init(key: String,
                     compare: EquatableFilter<V>.Compare? = nil,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(key: key, defaultValue: [], compare: compare, file: file, function: function, line: line)
    }
}

public extension EquatableFilter_ObservableObserverProjected_UserDefaultCodable where V: ExpressibleByDictionaryLiteral {
    convenience init(key: String,
                     compare: EquatableFilter<V>.Compare? = nil,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        
        self.init(key: key, defaultValue: [:], compare: compare, file: file, function: function, line: line)
    }
}
