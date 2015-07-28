//
//  ModelForm.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/24/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation

/// Receives delegation of model change events
public protocol ModelFormDelegate {
    func modelForm(modelForm: ModelForm, didSaveModel model: Any, fromModelFormController formController: ModelFormController)
}

///
public protocol ModelFormController {
    func setModel(model: Any, andModelForm modelForm: ModelForm)
    func setFormPropertyValue(value:Any, forPropertyNamed name: String)
    func saveFormToModel()
}

public protocol ModelFormModelAdapter {
    func initializeModel(modelProperties:[String: ModelForm.ModelPropertyMirror]) -> Any
}

protocol ModelFormSerializable {
    init(dictionary: [String: Any])
}


public struct ModelForm {
    
    //MARK: Reflection Info
    
    public typealias ModelPropertyMirror = (propertyIndex: Int, name: String, value: Any)
    
    //MARK: properties
    
    public let delegate: ModelFormDelegate
    public let model: Any
    public let formController: ModelFormController
    public let modelAdapter: ModelFormModelAdapter
    public let modelPropertyMirrorMap: [String: ModelPropertyMirror]
   
    
    //MARK: init
    
    public init(model: Any, delegate: ModelFormDelegate,
        formController: ModelFormController = ModelFormViewController(),
        modelAdapter: ModelFormModelAdapter) {
        self.model = model
        self.delegate = delegate
        self.formController = formController
        self.modelAdapter = modelAdapter
        self.modelPropertyMirrorMap = ModelForm.reflectOnModel(model)
        self.formController.setModel(self.model, andModelForm: self)
    }

    //MARK: Reflection (Inspect Model)

    public static func titlizeText(text: String) -> String{
        // I'm going to want to change field names into nicer label text so I might as well start pushing these things through the method and implement later
        return text
    }

    static func reflectOnModel(model: Any) -> [String: ModelPropertyMirror] {
            
        var propertMap: [String: ModelPropertyMirror] = [String: ModelPropertyMirror]()
            mirrorDo(model){ (propertyIndex: Int, field : String, value : Any) -> () in
                Logger.logVerbose("type:\(value.dynamicType), index: \(propertyIndex), field: \(field), value: \(value)")
                propertMap[field] = ModelPropertyMirror(propertyIndex: propertyIndex, name: field, value: value)
            }
            return propertMap
        }


}