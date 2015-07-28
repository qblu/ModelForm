//
//  PropertyTypeFormFieldFactory.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation
public enum PropertyType {
    case String
    case Int
    case Bool
}

public protocol FormFieldFactory {
    func createPropertyTypeFormField(value: Any) -> PropertyTypeFormField?
}

public struct PropertyTypeFormFieldFactory: FormFieldFactory {
    
    public func createPropertyTypeFormField(value: Any) -> PropertyTypeFormField? {
        if value is String {
            return createPropertyTypeFormField(propertyType:PropertyType.String)
        } else if value is Int {
            return createPropertyTypeFormField(propertyType:PropertyType.Int)
        } else if value is Bool {
            return createPropertyTypeFormField(propertyType:PropertyType.Bool)
        }
        return nil
    }
    
    func createPropertyTypeFormField(#propertyType: PropertyType) -> PropertyTypeFormField {
        switch propertyType{
        case .String:
            return StringTypeFormField()
        case .Int:
            return IntTypeFormField()
        case .Bool:
            return BoolTypeFormField()
        
        }
    }
}