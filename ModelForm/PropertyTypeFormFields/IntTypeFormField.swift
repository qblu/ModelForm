//
//  IntTypeFormField.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import UIKit

public struct IntTypeFormField: PropertyTypeFormField {
    
    public init(){}
    
    public func createFormField(fieldName: String, value: Any) -> UIControl {
        let textField = UITextField()
        if let intValue = value as? Int {
            textField.text = "\(intValue)"
            textField.placeholder = ModelForm.titlizeText(fieldName)
        }
        return textField
    }
    
    public func getValueFromFormField(formField: UIControl) -> (valid: Bool, value: Any) {
        if let textField = formField as? UITextField {
            if let intValue = textField.text.toInt() {
                return (valid: true, value: intValue)
            } else {
                return (valid: false, value: 0)
            }
        } else if let switchControl = formField as? UISwitch {
            let intValue = switchControl.on ? 1 : 0
            return (valid: true, value: intValue)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to IntTypeFormField.getValueFromFormField()")
            return (valid: false, value: 0)
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl) -> Bool {
        if let textField = formField as? UITextField {
            textField.text = "\(value)"
            return true
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to IntTypeFormField.updateValue()")
            return false
        }
    }
    
}
