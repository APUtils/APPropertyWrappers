//
//  UserDefault_Spec.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 14.12.23.
//  Copyright © 2023 Anton Plebanovich. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
@testable import APPropertyWrappers

final class UserDefault_Spec: QuickSpec {
    override static func spec() {
        describe("UserDefault") {
            context("when has optional value type and non-optional default value") {
                it("should work properly") {
                    let ud = UserDefault<Int?>(key: "UserDefault_Spec", defaultValue: 1)
                    ud.reset()
                    
                    expect(ud.wrappedValue) == 1
                    
                    ud.wrappedValue = nil
                    expect(ud.wrappedValue) == nil
                    
                    ud.reset()
                    expect(ud.wrappedValue) == 1
                    
                    ud.wrappedValue = nil
                    ud.removeFromUserDefaults()
                    expect(ud.wrappedValue) == nil
                    
                    ud.wrappedValue = 2
                    expect(ud.wrappedValue) == 2
                    
                    ud.reset()
                    expect(ud.wrappedValue) == 1
                }
            }
            
            context("when has optional value type and non-optional default value") {
                it("should work properly") {
                    let ud = UserDefault<Int?>(key: "UserDefault_Spec", defaultValue: nil)
                    ud.reset()
                    
                    expect(ud.wrappedValue) == nil
                    
                    ud.wrappedValue = 1
                    expect(ud.wrappedValue) == 1
                    
                    ud.reset()
                    expect(ud.wrappedValue) == nil
                    
                    ud.wrappedValue = 2
                    ud.removeFromUserDefaults()
                    expect(ud.wrappedValue) == 2
                    
                    ud.wrappedValue = nil
                    expect(ud.wrappedValue) == nil
                    
                    ud.reset()
                    expect(ud.wrappedValue) == nil
                }
            }
        }
    }
}
