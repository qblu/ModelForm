//
//  PropertyTypeFormField.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

public protocol PropertyTypeFormField {
    init()
    func createFormField(fieldName: String, value: Any) -> UIControl
    func getValueFromFormField(formField: UIControl) -> (valid: Bool, value: Any)
    func updateValue(value: Any, onFormField formField: UIControl) -> Bool
}
