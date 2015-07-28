//
//  ModelFormValidationResult.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

public struct ModelFormValidationResult {
    public private(set) var validationItems: [ModelFormValidationItem] = []
    public var isValid: Bool {
        get{
            for item in validationItems {
                if(!item.isValid) {return false}
            }
            return true
        }
    }
}