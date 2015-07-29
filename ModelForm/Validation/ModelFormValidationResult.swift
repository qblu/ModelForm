//
//  ModelFormValidationResult.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

public class ModelFormValidationResult {
    
    public class ModelFormValidationItem {
        
        public var valid: Bool {
            get {
                return validationMessages.count == 0
            }
        }
        
        public private(set) var propertyName: String
        public var validationMessages: [String] = []
        public init(propertyName: String) {
            self.propertyName = propertyName
        }
    }

    
    public var validationItems: [ModelFormValidationItem] = []
    public var valid: Bool {
        get{
            for item in validationItems {
                if(!item.valid) {return false}
            }
            return true
        }
    }
    
    public init(){}
    
    public convenience init(invalidPropertyName: String, validationMessage: String) {
        self.init()
        recordValidationViolation(invalidPropertyName, validationMessage: validationMessage)
    }
    
    public class func validResult() -> ModelFormValidationResult {
        // abstract the knowledge that a new, empty result is implicitly valid
        return ModelFormValidationResult()
    }
    
    
    public func findValidationItemWithName(propertyName: String) -> ModelFormValidationItem? {
        return validationItems.filter() { return $0.propertyName == propertyName}.last
    }
    
    public func recordValidationViolation(propertyName: String, validationMessage: String) {
        let validationItem: ModelFormValidationItem
        
        if let item = findValidationItemWithName(propertyName) {
            validationItem = item
        } else {
            validationItem = ModelFormValidationItem(propertyName: propertyName)
            validationItems.append(validationItem)
        }
        
        validationItem.validationMessages.append(validationMessage)
    }
}

