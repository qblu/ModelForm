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
    
    public func getValueFromFormField(formField: UIControl, forPropertyNamed propertyName: String) -> (validationResult: ModelFormValidationResult, value: Any) {
        if let textField = formField as? UITextField {
            return (validationResult: ModelFormValidationResult.validResult(), value: textField.text)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to StringTypeFormField.getValueFromFormField()")
            return (validationResult:ModelFormValidationResult(invalidPropertyName: propertyName, validationMessage: "The form field provided for update was of the wrong type.  Expected a UITextField."), value: "")
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl, forPropertyNamed name: String) -> ModelFormValidationResult {
        if let textField = formField as? UITextField {
            textField.text = "\(value)"
            return ModelFormValidationResult.validResult()
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to StringTypeFormField.updateValue()")
            return ModelFormValidationResult(invalidPropertyName: name, validationMessage: "The form field provided for update was of the wrong type.  Expected a UISwitch.")
        }
    }

}

