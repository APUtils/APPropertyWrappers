//
//  UserDefaultCodable+ObserverType.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import RxSwift

extension UserDefaultCodable: ObserverType {
    
    public typealias Element = V
    
    public func on(_ event: Event<V>) {
        switch event {
        case .next(let element): wrappedValue = element
        default: return
        }
    }
}
