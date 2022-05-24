//
//  FilePreserved_Spec.swift
//  APPropertyWrappers
//
//  Created by Anton Plebanovich on 24.05.22.
//  Copyright © 2022 Anton Plebanovich. All rights reserved.
//

import Nimble
import Nimble_Snapshots
import Quick
@testable import APPropertyWrappers

class FilePreserved_Spec: QuickSpec {
    override func spec() {
        describe("FilePreserved") {
            var preserved: FilePreserved!
            
            afterEach {
                preserved?.reset()
                preserved = nil
            }
            
            context("when using false as default value") {
                beforeEach {
                    preserved = FilePreserved(key: "FilePreserved_Spec_spec", defaultValue: "false")
                }
                
                it("should work properly") {
                    expect(preserved.wrappedValue) == "false"
                    
                    preserved.wrappedValue = "true"
                    expect(preserved.wrappedValue) == "true"
                    
                    preserved = FilePreserved(key: "FilePreserved_Spec_spec", defaultValue: "false")
                    expect(preserved.wrappedValue) == "true"
                    
                    preserved.wrappedValue = "false"
                    expect(preserved.wrappedValue) == "false"
                    
                    preserved.reset()
                    expect(preserved.wrappedValue) == "false"
                    
                    preserved.wrappedValue = "false"
                    expect(preserved.wrappedValue) == "false"
                }
            }
        }
    }
}
