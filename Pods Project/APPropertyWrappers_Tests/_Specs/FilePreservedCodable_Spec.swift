//
//  FilePreservedCodable_Spec.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 5.09.24.
//  Copyright © 2024 Anton Plebanovich. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
@testable import APPropertyWrappers

final class FilePreservedCodable_Spec: QuickSpec {
    override static func spec() {
        describe("FilePreservedCodable") {
            context("when have Date type") {
                var preserved: FilePreservedCodable<Date>!
                
                beforeEach {
                    preserved = FilePreservedCodable(key: "spec")
                }
                
                afterEach {
                    preserved?.reset()
                    preserved = nil
                }
                
                it("should work properly") {
                    expect(preserved.wrappedValue) == nil
                    
                    let date1 = Date(timeIntervalSince1970: 1)
                    preserved.wrappedValue = date1
                    expect(preserved.wrappedValue) == date1
                    
                    preserved = FilePreservedCodable(key: "spec")
                    expect(preserved.wrappedValue) == date1
                    
                    let date2 = Date(timeIntervalSince1970: 2)
                    preserved.wrappedValue = date2
                    expect(preserved.wrappedValue) == date2
                    
                    preserved.reset()
                    expect(preserved.wrappedValue) == nil
                    
                    preserved.wrappedValue = date2
                    expect(preserved.wrappedValue) == date2
                }
            }
        }
    }
}
