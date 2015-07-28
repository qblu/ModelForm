//
//  StringTypeFormFieldSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Quick
import Nimble
import ModelForm

class StringTypeFormFieldSpec: QuickSpec {
    
    override func spec() {
        
        describe(".createFormField") {
            
            context("When a string is passed as value") {

                
                it("creates a UITextField with text set to value") {
                    let field = StringTypeFormField().createFormField("someName", value: "someValue") as! UITextField
                    expect(field.text).to(equal("someValue"))
                }
            }
            
            context("When a number is passed as value") {
                
                
                it("returns a UITextField with empty text") {
                    let field = StringTypeFormField().createFormField("someName", value: 6) as! UITextField
                    expect(field.text).to(equal(""))
                }
            }
        }
        
        describe(".getValueFromFormField") {
            
            context("When a text field is passed as formField") {
                
                it("returns the valid text") {
                    let textField = UITextField()
                    textField.text = "Nifty"
                    let (valid, value) = StringTypeFormField().getValueFromFormField(textField)
                    expect(valid).to(beTrue())
                    
                    expect((value as! String)).to(equal("Nifty"))
                }
            }
            
            context("When a switch field is passed as formField") {
                
                it("returns an empty string") {
                    let switchControl = UISwitch()
                    switchControl.on = true
                    let (valid, value) = StringTypeFormField().getValueFromFormField(switchControl)
                    expect(valid).to(beFalse())
                    expect((value as! String)).to(equal(""))
                }
            }
        }
    }
}



