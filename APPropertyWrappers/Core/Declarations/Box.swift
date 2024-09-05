//
//  Box.swift
//  Pods
//
//  Created by Anton Plebanovich on 5.09.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation

public struct Box<V: Codable>: Codable {
    public let value: V
    public init(value: V) {
        self.value = value
    }
}
