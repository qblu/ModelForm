//
//  StringTypeFormField.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import UIKit

public struct StringTypeFormField: PropertyTypeFormField {
    
    public init(){}
    
    public func createFormField(fieldName: String, value: Any) -> UIControl {
        let textField = UITextField()
        if let text = value as? String {
            textField.text = text
            textField.placeholder = ModelForm.titlizeText(fieldName)
        }
        return textField
    }
    
    public func getValueFromFormField(formField: UIControl) -> (valid: Bool, value: Any) {
        if let textField = formField as? UITextField {
            return (valid: true, value: textField.text)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to StringTypeFormField.getValueFromFormField()")
            return (valid: false, value: "")
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl) -> Bool {
        if let textField = formField as? UITextField {
            textField.text = "\(value)"
            return true
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to StringTypeFormField.updateValue()")
            return false
        }
    }

}

