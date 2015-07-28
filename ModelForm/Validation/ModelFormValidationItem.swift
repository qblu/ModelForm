//
//  ModelFormValidationItem.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//


public struct ModelFormValidationItem {
    public var isValid: Bool {
        get {
            return validationMessages.count == 0
        }
    }
    
    public private(set) var propertyName: String
    public private(set) var validationMessages: [String]
    init(propertyName: String) {
        validationMessages = []
        self.propertyName = propertyName
    }
}
