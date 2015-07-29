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
    
    public func getValueFromFormField(formField: UIControl, forPropertyNamed propertyName: String) -> (validationResult: ModelFormValidationResult, value: Any) {
        if let field = formField as? UISwitch {
            let switchIsOn: Bool = field.on
            return (validationResult: ModelFormValidationResult.validResult(), value: switchIsOn)
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] sent to BoolTypeFormField.getValueFromFormField()")
            return (validationResult:ModelFormValidationResult(invalidPropertyName: propertyName, validationMessage: "The form field provided for update was of the wrong type.  Expected a UISwitch."), value: false)
          
        }
    }
    
    public func updateValue(value: Any, onFormField formField: UIControl, forPropertyNamed name: String) -> ModelFormValidationResult {
        if let field = formField as? UISwitch, castValue = value as? Bool {
            field.setOn(castValue, animated: true)
            return ModelFormValidationResult.validResult()
        } else {
            Logger.logWarning("Unexpected form field type:[\(formField.dynamicType)] or value type:[\(value.dynamicType)] sent to BoolTypeFormField.updateValue()")
            var validationresult = ModelFormValidationResult()
            validationresult.recordValidationViolation(name, validationMessage: "The form field used for update was not of the correct type.  Expected a UISwitch.")
            return validationresult
        }
    }
    
}
