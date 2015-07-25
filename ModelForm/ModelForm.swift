//
//  ModelForm.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/24/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation

public protocol ModelFormDelegate {
    func modelForm(modelForm: ModelForm, didSaveModel model: Any, fromModelFormActor modelFormActor: ModelFormActor)
}

public protocol ModelFormActor {
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
    
    class ModelFormViewController: UIViewController, ModelFormActor {
        
        private var modelForm: ModelForm!
        private var model: Any!
        private var formFields: [String: UIControl]!
        
        func setModel(model: Any, andModelForm modelForm: ModelForm) {
            self.model = model
            self.modelForm = modelForm
            
            formFields = createFormFieldsForModel(modelForm.modelPropertyMirrorMap)
        }
        
        func setFormPropertyValue(value:Any, forPropertyNamed name: String) {
            if let formField = formFields[name] {
                if var textField = formField as? UITextField, textValue = value as? String {
                    (formFields[name] as! UITextField).text = textValue
                    println(textField)
                }
            }
        }
        
        func getFormFieldStringValue(formField: UIControl) -> (found: Bool, text: String) {
            if let textField = formField as? UITextField {
                return (found:true, text: textField.text)
            }
            
            return (found:false, text: "")
        }
        
        func saveFormToModel() {
            
            // copy data from form to copy of property map
            var updatedPropertyMap = modelForm.modelPropertyMirrorMap
            
            for (name, formField) in self.formFields {
                println("name: \(name) is \(formField)")
                let (found, text) = getFormFieldStringValue(formField)
                if(found) {
                    updatedPropertyMap[name]!.value = text
                }
            }
            
            // pass the updated property map to the model adapter.  A new model will be initialized from this map.
            // The details for how to do this are up to the consumer.  At this time, and to the best of my knowledge,
            // this is not possible to do dynamically using Swift's present reflection capabilities.
            let updatedModel = self.modelForm.modelAdapter.initializeModel(updatedPropertyMap)
            
            // tell delegate to save changes
            self.modelForm.delegate.modelForm(self.modelForm, didSaveModel: updatedModel, fromModelFormActor: self)
        }
        
      
        
        func createTextField(fieldName: String, text: String) -> UITextField {
            let textField = UITextField()
            textField.text = text
            textField.placeholder = modelForm.titlizeText(fieldName)
            return textField
        }
        
        
        func createFormFieldsForModel( reflectedPropertyMap: [String: ModelForm.ModelPropertyMirror] ) -> [String: UIControl] {
            var fields = [String: UIControl]()
            
            for (proeprtyName, mirror) in reflectedPropertyMap {
                println("type:\(mirror.value.dynamicType), index: \(mirror.propertyIndex), field: \(mirror.name), value: \(mirror.value)")
                if let stringValue = mirror.value as? String {
                    fields[mirror.name] = self.createTextField(mirror.name, text: stringValue)
                }
            }
            return fields
        }
    }
    
    public typealias ModelPropertyMirror = (propertyIndex: Int, name: String, value: Any)
    
    public let delegate: ModelFormDelegate
    public let model: Any
    public let modelFormActor: ModelFormActor
    public let modelAdapter: ModelFormModelAdapter
    public let modelPropertyMirrorMap: [String: ModelPropertyMirror]
   
    
    public init(model: Any, delegate: ModelFormDelegate, actor: ModelFormActor = ModelFormViewController(), modelAdapter: ModelFormModelAdapter) {
        self.model = model
        self.delegate = delegate
        self.modelFormActor = actor
        self.modelAdapter = modelAdapter
        self.modelPropertyMirrorMap = ModelForm.reflectOnModel(model)
        self.modelFormActor.setModel(self.model, andModelForm: self)
        
    }


    public func titlizeText(text: String) -> String{
        // I'm going to want to change field names into nicer label text so I might as well start pushing these things through the method and implement later
        return text
    }

    static func reflectOnModel(model: Any) -> [String: ModelPropertyMirror] {
            
        var propertMap: [String: ModelPropertyMirror] = [String: ModelPropertyMirror]()
            mirrorDo(model){ (propertyIndex: Int, field : String, value : Any) -> () in
                println("type:\(value.dynamicType), index: \(propertyIndex), field: \(field), value: \(value)")
                propertMap[field] = ModelPropertyMirror(propertyIndex: propertyIndex, name: field, value: value)
            }
            return propertMap
        }

}