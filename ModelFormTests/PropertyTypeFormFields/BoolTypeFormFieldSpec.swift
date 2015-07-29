//
//  BoolTypeFormFieldSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//


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

class BoolTypeFormFieldSpec: QuickSpec {
    
    override func spec() {
        
        describe(".createFormField") {
            
            context("When a bool is passed as value") {
                
                
                it("returns a UISwitch with on state reflecting value") {
                    let field = BoolTypeFormField().createFormField("someName", value: false) as! UISwitch
                    expect(field.on).to(beFalse())
                    
                    let field2 = BoolTypeFormField().createFormField("someName", value: true) as! UISwitch
                    expect(field.on).to(beFalse())
                }
            }
        }
        
        describe(".getValueFromFormField") {
            
            context("When a UISwitch field is passed as formField") {
                
                it("returns on state as bool") {
                    let field = UISwitch()
                    field.on = true
                    let (validationResult, value) = BoolTypeFormField().getValueFromFormField(field, forPropertyNamed: "doesnt_matter")
                    expect(validationResult.valid).to(beTrue())
                    expect((value as! Bool)).to(beTrue())
                    
                    field.on = false
                    let (validationResult2, value2) = BoolTypeFormField().getValueFromFormField(field, forPropertyNamed: "doesnt_matter")
                    expect(validationResult2.valid).to(beTrue())
                    expect((value2 as! Bool)).to(beFalse())
                }
            }
            
            context("When a switch field is passed as formField") {
                
                it("returns 0 or 1 accordingly") {
                    let switchControl = UISwitch()
                    switchControl.on = true
                    let (validationResult, value) = IntTypeFormField().getValueFromFormField(switchControl, forPropertyNamed: "doesnt_matter")
                    expect(validationResult.valid).to(beTrue())
                    expect((value as! Int)).to(equal(1))
                    
                    
                    switchControl.on = false
                    let (validationResult2, value2) = IntTypeFormField().getValueFromFormField(switchControl, forPropertyNamed: "doesnt_matter")
                    expect(validationResult2.valid).to(beTrue())
                    expect((value2 as! Int)).to(equal(0))
                }
            }
        }
        
        describe(".updateValue:") {
            
            context("When a UISwitch field is passed as formField") {
                
                it("returns on state as bool") {
                    let field = UISwitch()
                    field.on = false
                    let success = BoolTypeFormField().updateValue(true, onFormField: field, forPropertyNamed: "YesMan").valid
                    expect(success).to(beTrue())
                    expect(field.on).to(beTrue())
                    
                    let field2 = UISwitch()
                    field2.on = true
                    let success2 = BoolTypeFormField().updateValue(false, onFormField: field2, forPropertyNamed: "YesMan").valid
                    expect(success2).to(beTrue())
                    expect(field2.on).to(beFalse())
                }
            }
            
        }
    }
}






