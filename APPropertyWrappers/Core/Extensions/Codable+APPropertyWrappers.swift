//
//  Codable+APPropertyWrappers.swift
//  Pods
//
//  Created by Anton Plebanovich on 5.09.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Foundation

extension Encodable {
    
    /// Encodes the object into a property list.
    func propertyListEncoded() throws -> Data {
        let encoder = PropertyListEncoder()
        return try encoder.encode(self)
    }
}

extension Decodable {
    
    /// Creates object from property list data.
    static func create(propertyListData: Data) throws -> Self {
        let decoder = PropertyListDecoder()
        return try decoder.decode(Self.self, from: propertyListData)
    }
}
