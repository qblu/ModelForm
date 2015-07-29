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
    
    public func getValueFromFormField(formField: UIControl, forPropertyNamed propertyName: String) -> (validationResult: ModelFormValidationResult, value: Any) {
        if let textField = formField as? UITextField {
            if let intValue = textField.text.toInt() {
                return (ModelFormValidationResult.validResult(), value: intValue)
            } else {
                return (validationResult:ModelFormValidationResult(invalidPropertyName: propertyName, validationMessage: "The value must be a whole number"), value: 0)
            }
        } else if let switchControl = formField as? UISwitch {
            let intValue = switchControl.on ? 1 : 0
            return (ModelFormValidationResult.validResult(), value: intValue)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to IntTypeFormField.getValueFromFormField()")
            return (validationResult:ModelFormValidationResult(invalidPropertyName: "", validationMessage: "The form field provided for update was of the wrong type.  Expected a UITextField"), value: 0)
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl, forPropertyNamed name: String) -> ModelFormValidationResult {
        if let textField = formField as? UITextField {
            if let intValue = value as? Int {
                // cool, fall through
            } else if let stringValue = value as? String {
                // can't cast as Int, try string
                if let intValue = stringValue.toInt() {
                    // cool, fall through
                } else {
                    // can't parse string to int
                    textField.text = ""
                    return ModelFormValidationResult(invalidPropertyName: name, validationMessage: "Text value provided could not be parsed as an Integer.  A whole number is required.")
                }
            } else {
                // unhandled type
                textField.text = ""
                return ModelFormValidationResult(invalidPropertyName: name, validationMessage: "Value provided could not be cast as an Integer.  A whole number is required.")
            }
            // fell through so all good
            textField.text = "\(value)"
            return ModelFormValidationResult.validResult()
        } else {
            // not a text field.  Totally unexpected
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to IntTypeFormField.updateValue()")
            return ModelFormValidationResult(
                invalidPropertyName: name,
                validationMessage: "The form field used for update was not of the correct type.  Expected a UITextField"
            )

        }
    }
    
}
