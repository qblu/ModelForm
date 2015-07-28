//
//  BoolTypFormField.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//


import UIKit

public struct BoolTypeFormField: PropertyTypeFormField {
    
    public init(){}
    
    public func createFormField(fieldName: String, value: Any) -> UIControl {
        let field = UISwitch()
        if let castValue = value as? Bool {
            field.on = castValue
        }
        return field
    }
    
    public func getValueFromFormField(formField: UIControl) -> (valid: Bool, value: Any) {
        if let field = formField as? UISwitch {
            let switchIsOn: Bool = field.on
            return (valid: true, value: switchIsOn)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to BoolTypeFormField.getValueFromFormField()")
            return (valid: false, value: false)
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl) -> Bool {
        if let field = formField as? UISwitch, castValue = value as? Bool {
            field.setOn(castValue, animated: true)
            return true
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] or value type:[\(value.dynamicType)] sent to BoolTypeFormField.updateValue()")
            return false
        }
    }
    
}
