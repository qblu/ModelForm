//
//  IntTypeFormFieldSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Quick
import Nimble
import ModelForm

class IntTypeFormFieldSpec: QuickSpec {
    
    override func spec() {
        
        describe(".createFormField") {
            
            context("When a number is passed as value") {
                
                
                it("returns a UITextField with text as value") {
                    let field = IntTypeFormField().createFormField("someName", value: 6) as! UITextField
                    expect(field.text).to(equal("6"))
                }
            }
            
            context("When a string is passed as value") {
                
                it("creates a UITextField with empty text") {
                    let field = IntTypeFormField().createFormField("someName", value: "someValue") as! UITextField
                    expect(field.text).to(equal(""))
                }
            }
            
            
        }
        
        describe(".getValueFromFormField") {
            
            context("When a text field is passed as formField") {
                
                it("returns valid whole number as Int") {
                    let textField = UITextField()
                    textField.text = "99"
                    let (validationResult, value) = IntTypeFormField().getValueFromFormField(textField, forPropertyNamed: "doesnt_matter")
                    expect(validationResult.valid).to(beTrue())
                    
                    expect((value as! Int)).to(equal(99))
                }
            }
            
            context("When a switch field is passed as formField") {
                
                it("returns 0 or 1 accordingly") {
                    let switchControl = UISwitch()
                    switchControl.on = true
                    let (validationResult, value) = IntTypeFormField().getValueFromFormField(switchControl, forPropertyNamed: "yep")
                    expect(validationResult.valid).to(beTrue())
                    expect((value as! Int)).to(equal(1))

                
                    switchControl.on = false
                    let (validationResult2, value2) = IntTypeFormField().getValueFromFormField(switchControl, forPropertyNamed: "hi ho")
                    expect(validationResult2.valid).to(beTrue())
                    expect((value2 as! Int)).to(equal(0))
}
            }
        }
        
        describe(".updateValue(onFormField) ") {
            context("When a whole number is given") {
                it("sets the value and returns valid result") {
                    var textField = UITextField()
                    let validationResult = IntTypeFormField().updateValue(999, onFormField:textField, forPropertyNamed: "goofy")
                    expect(validationResult.valid).to(beTrue())
                    expect(textField.text).to(equal("999"))

                }
            }
            
            pending("When a float number is given") {
                it("sets the rounded value and returns invalid result") {
                    
                    // not sure if this is even desirable.  It requires a NumberFormatter and just not going to go that far today
                    var textField = UITextField()
                    let validationResult = IntTypeFormField().updateValue(99.9, onFormField:textField, forPropertyNamed: "goofy")
                    expect(validationResult.valid).to(beFalse())
                    expect(textField.text).to(equal("100"))
                }
            }
            
            context("When a string is given") {
                it("sets 0 and returns invalid result") {
                    var textField = UITextField()
                    let validationResult = IntTypeFormField().updateValue("whoa", onFormField:textField, forPropertyNamed: "goofy")
                    expect(validationResult.valid).to(beFalse())
                    expect(textField.text).to(equal(""))
                }
            }
        }
    }
}



