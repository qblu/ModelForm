 //
//  ModelFormValidationResultSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ModelForm

class ModelFormValidationResultSpec: QuickSpec {
    
    override func spec() {
        
        beforeEach { /* Executes before each test and prior to nested beforeEach */ }
        
        describe(".valid") {
        
            context("When validations items report their valid state") {
                beforeEach { }
                it("reports valid only if ll items are valid") {
                    // test expectations
                    let validationResult = ModelFormValidationResult()
                    let item1 = ModelFormValidationResult.ModelFormValidationItem(propertyName:"something")
                    let item2 = ModelFormValidationResult.ModelFormValidationItem(propertyName:"something2")
                    let item3 = ModelFormValidationResult.ModelFormValidationItem(propertyName:"something3")
                    validationResult.validationItems.append(item1)
                    validationResult.validationItems.append(item2)
                    validationResult.validationItems.append(item3)
                    expect(validationResult.valid).to(beTrue())
                    
                    // item 2 is now invalid
                    item2.validationMessages.append("Bad dog")
                    
                    // so result should be invalid
                    expect(validationResult.valid).to(beFalse())

                }
            }
        
            context("When a validationItem has messages") {
                beforeEach { }
                it("reports being invalid") {
                    let item1 = ModelFormValidationResult.ModelFormValidationItem(propertyName:"something")
                    expect(item1.valid).to(beTrue())
                    item1.validationMessages.append("Alas, not good")
                    expect(item1.valid).to(beFalse())
                }
            }
        }
        
        describe(".validResult") {
            it("should be valid") {
                let shouldBeValid = ModelFormValidationResult.validResult()
                expect(shouldBeValid.valid).to(beTrue())
            }
        }
        
        describe(".recordValidationViolation") {
            it("appends messages to the matching or new item") {
                var validationResult = ModelFormValidationResult()
                
                validationResult.recordValidationViolation("something", validationMessage: "That's it")
                expect(validationResult.validationItems.count).to(equal(1))
                expect(validationResult.validationItems[0].validationMessages.count).to(equal(1))
                
                validationResult.recordValidationViolation("else", validationMessage: "That's it")
                
                expect(validationResult.validationItems.count).to(equal(2))
                expect(validationResult.validationItems[0].validationMessages.count).to(equal(1))
                
                validationResult.recordValidationViolation("something", validationMessage: "That's another")
                expect(validationResult.validationItems.count).to(equal(2))
                expect(validationResult.validationItems[0].validationMessages.count).to(equal(2))
                
                
            }
        }
        
        describe(".mergeResults") {
            
            context("When result items have propertyName matches") {
                it("combines matching items") {
                    var results1 = ModelFormValidationResult()
                    results1.recordValidationViolation("match1", validationMessage: "I'm a message")
                    results1.recordValidationViolation("match2", validationMessage: "I'm a message 2")
                    results1.recordValidationViolation("notamatch1", validationMessage: "I'm a message 3")
                    results1.recordValidationViolation("match3", validationMessage: "I'm a message 4")
                    results1.recordValidationViolation("notamatch2", validationMessage: "I'm a message 5")

                
                    var results2 = ModelFormValidationResult()
                    
                    results2.recordValidationViolation("notamatch3", validationMessage: "I'm a message 6")
                    results2.recordValidationViolation("match3", validationMessage: "I'm a message 7")
                    results2.recordValidationViolation("match1", validationMessage: "I'm a message 8")
                    results2.recordValidationViolation("match2", validationMessage: "I'm a message 9")
                    results2.recordValidationViolation("notamatch4", validationMessage: "I'm a message 10")
                    
                    results1.mergeResults(results2)
                    
                    expect(results1.validationItems.count).to(equal(7))
                    expect(results1.findValidationItemWithName("match1")?.validationMessages.count).to(equal(2))
}
            }
        }
    }
}



