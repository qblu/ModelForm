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
                    let (valid, value) = IntTypeFormField().getValueFromFormField(textField)
                    expect(valid).to(beTrue())
                    
                    expect((value as! Int)).to(equal(99))
                }
            }
            
            context("When a switch field is passed as formField") {
                
                it("returns 0 or 1 accordingly") {
                    let switchControl = UISwitch()
                    switchControl.on = true
                    let (valid, value) = IntTypeFormField().getValueFromFormField(switchControl)
                    expect(valid).to(beTrue())
                    expect((value as! Int)).to(equal(1))

                
                    switchControl.on = false
                    let (valid2, value2) = IntTypeFormField().getValueFromFormField(switchControl)
                    expect(valid2).to(beTrue())
                    expect((value2 as! Int)).to(equal(0))
}
            }
        }
    }
}



