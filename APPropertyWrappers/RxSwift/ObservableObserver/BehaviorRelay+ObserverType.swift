//
//  BehaviorRelay+ObserverType.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 3/20/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

extension BehaviorRelay: @retroactive ObserverType {
    
    // swiftlint:disable:next excessive_public_other_modifier
    public func on(_ event: Event<Element>) {
        switch event {
        case .next(let element): accept(element)
        default: return
        }
    }
}
