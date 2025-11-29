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

final class FilePreserved_Spec: QuickSpec {
    
    static let key = "FilePreserved_Spec_spec"
    static let gt: FilePreserved.Transform = { $0.map { String($0.dropLast()) } }
    static let st: FilePreserved.Transform = { $0?.appending("!") }
    
    override static func spec() {
        describe("FilePreserved") {
            var preserved: FilePreserved!
            
            afterEach {
                preserved?.reset()
                preserved = nil
                
                // Prevent default value capture
                FilePreserved(key: key, defaultValue: nil).reset()
            }
            
            context("when no transform") {
                context("when have nil default value") {
                    beforeEach {
                        preserved = FilePreserved(key: key, defaultValue: nil)
                    }
                    
                    it("should work properly") {
                        expect(preserved.wrappedValue) == nil
                        
                        preserved.wrappedValue = "true"
                        expect(preserved.wrappedValue) == "true"
                        
                        preserved = FilePreserved(key: key, defaultValue: nil)
                        expect(preserved.wrappedValue) == "true"
                        
                        preserved.wrappedValue = "false"
                        expect(preserved.wrappedValue) == "false"
                        
                        preserved.reset()
                        expect(preserved.wrappedValue) == nil
                        
                        preserved.wrappedValue = "false"
                        expect(preserved.wrappedValue) == "false"
                    }
                } // when have nil default value
                
                context("when have default value") {
                    context("and default preserved") {
                        beforeEach {
                            preserved = FilePreserved(key: key, defaultValue: "1", preserveDefault: true)
                        }
                        
                        it("should work properly") {
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: true)
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved.wrappedValue = "true"
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: true)
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                            
                            preserved.reset()
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                        }
                    } // and default preserved
                    
                    context("and default not preserved") {
                        beforeEach {
                            preserved = FilePreserved(key: key, defaultValue: "1", preserveDefault: false)
                        }
                        
                        it("should work properly") {
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: false)
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "true"
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: false)
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                            
                            preserved.reset()
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                        }
                    } // and default not preserved
                } // when have default value
            } // when no transform
            
            context("when have transform") {
                context("when have nil default value") {
                    beforeEach {
                        preserved = FilePreserved(key: key, defaultValue: nil, setTransform: st, getTransform: gt)
                    }
                    
                    it("should work properly") {
                        expect(preserved.wrappedValue) == nil
                        
                        preserved.wrappedValue = "true"
                        expect(preserved.wrappedValue) == "true"
                        
                        preserved = FilePreserved(key: key, defaultValue: nil, setTransform: st, getTransform: gt)
                        expect(preserved.wrappedValue) == "true"
                        
                        preserved.wrappedValue = "false"
                        expect(preserved.wrappedValue) == "false"
                        
                        preserved.reset()
                        expect(preserved.wrappedValue) == nil
                        
                        preserved.wrappedValue = "false"
                        expect(preserved.wrappedValue) == "false"
                    }
                } // when have nil default value
                
                context("when have default value") {
                    context("and default preserved") {
                        beforeEach {
                            preserved = FilePreserved(key: key, defaultValue: "1", preserveDefault: true, setTransform: st, getTransform: gt)
                            preserved.reset()
                        }
                        
                        it("should work properly") {
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: true, setTransform: st, getTransform: gt)
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved.wrappedValue = "true"
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: true, setTransform: st, getTransform: gt)
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                            
                            preserved.reset()
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                        }
                    } // and default preserved
                    
                    context("and default not preserved") {
                        beforeEach {
                            preserved = FilePreserved(key: key, defaultValue: "1", preserveDefault: false, setTransform: st, getTransform: gt)
                            preserved.reset()
                        }
                        
                        it("should work properly") {
                            expect(preserved.wrappedValue) == "1"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: false, setTransform: st, getTransform: gt)
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "true"
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved = FilePreserved(key: key, defaultValue: "2", preserveDefault: false, setTransform: st, getTransform: gt)
                            expect(preserved.wrappedValue) == "true"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                            
                            preserved.reset()
                            expect(preserved.wrappedValue) == "2"
                            
                            preserved.wrappedValue = "false"
                            expect(preserved.wrappedValue) == "false"
                        }
                    } // and default not preserved
                } // when have default value
            } // when have transform
        }
    }
}
