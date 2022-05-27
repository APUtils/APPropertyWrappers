//
//  ObservableObserver.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 7/31/20.
//  Copyright © 2020 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

typealias ObservableObserverType = ObservableType & ObserverType

/// Class that is both observable and observer.
open class ObservableObserver<Element>: ObservableObserverType {
    
    fileprivate let observer: AnyObserver<Element>
    fileprivate let observable: Observable<Element>
    
    init(observer: AnyObserver<Element>, observable: Observable<Element>) {
        self.observer = observer
        self.observable = observable
    }
    
    // ******************************* MARK: - ObservableType
    
    open func subscribe<Observer>(_ observer: Observer) -> Disposable where Observer: ObserverType, Element == Observer.Element {
        observable.subscribe(observer)
    }
    
    open func asObservable() -> Observable<Element> {
        observable
    }
    
    // ******************************* MARK: - ObserverType
    
    open func on(_ event: Event<Element>) {
        observer.on(event)
    }
    
    open func asObserver() -> AnyObserver<Element> {
        observer
    }
}

// ******************************* MARK: - Extensions

extension ObservableObserver {
    open func accept(_ element: Element) {
        observer.onNext(element)
    }
}

// ******************************* MARK: - Rx

extension ObservableType where Self: ObserverType {
    public func asObservableObserver() -> ObservableObserver<Element> {
        ObservableObserver(observer: asObserver(), observable: asObservable())
    }
}
