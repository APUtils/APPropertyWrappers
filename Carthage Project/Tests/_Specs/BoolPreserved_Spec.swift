//
//  BoolPreserved_Spec.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 4/6/21.
//  Copyright © 2021 Anton Plebanovich. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
@testable import APPropertyWrappers

class BoolPreserved_Spec: QuickSpec {
    override func spec() {
        describe("BoolPreserved") {
            var preserved: BoolPreserved!
            
            afterEach {
                preserved?.reset()
                preserved = nil
            }
            
            context("when using false as default value") {
                beforeEach {
                    preserved = BoolPreserved(key: "BoolPreserved_Spec_spec", defaultValue: false)
                }
                
                it("should work properly") {
                    expect(preserved.wrappedValue) == false
                    
                    preserved.wrappedValue = true
                    expect(preserved.wrappedValue) == true
                    
                    preserved.wrappedValue = false
                    expect(preserved.wrappedValue) == false
                    
                    preserved.reset()
                    expect(preserved.wrappedValue) == false
                    
                    preserved.wrappedValue = false
                    expect(preserved.wrappedValue) == false
                }
            }
            
            context("when using true as default value") {
                beforeEach {
                    preserved = BoolPreserved(key: "BoolPreserved_Spec_spec", defaultValue: true)
                }
                
                it("should work properly") {
                    expect(preserved.wrappedValue) == true
                    
                    preserved.wrappedValue = false
                    expect(preserved.wrappedValue) == false
                    
                    preserved.wrappedValue = true
                    expect(preserved.wrappedValue) == true
                    
                    preserved.reset()
                    expect(preserved.wrappedValue) == true
                    
                    preserved.wrappedValue = true
                    expect(preserved.wrappedValue) == true
                }
            }
        }
    }
}
