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


// the following was yanked from https://tetontech.wordpress.com/2014/10/24/swift-reflection-downcasting-protocols-and-structs-a-solution/
// It gets the job done but places quite a bit of responsibility on the model 
protocol KeyValueCodable{
    var KVTypeName:String {get}
    init()
    subscript(index:String)->Any? { get set }
    func instantiate()->KeyValueCodable
    func downCastFromAny(anAny:Any)->KeyValueCodable?
}


public struct ModelForm {
    
    class ModelFormViewController: UIViewController, ModelFormActor {
        
        private var modelForm: ModelForm!
        private var model: Any!
        private var formFields: [String: UIControl]!
        
        func setModel(model: Any, andModelForm modelForm: ModelForm) {
            self.model = model
            self.modelForm = modelForm
            formFields = createFormFieldsForModel()
        }
        
        func setFormPropertyValue(value:Any, forPropertyNamed name: String) {
            if let formField = formFields[name] {
                if let textField = formField as? UITextField, textValue = value as? String {
                    textField.text = textValue
                }
            }
        }
        
        func saveFormToModel() {
            
            // copy data to model
            
            for (name, formField) in self.formFields {
                println("name: \(name)")
                
            }
            
            // tell delegate to save changes
            self.modelForm.delegate.modelForm(self.modelForm, didSaveModel: self.model, fromModelFormActor: self)
        }
        
        func createTextField(name: String, text: String) -> UITextField {
            let textField = UITextField()
            textField.text = text
            textField.placeholder = name
            return textField
        }
        
        func createFormFieldsForModel() -> [String: UIControl] {
            var fields = [String: UIControl]()
            mirrorDo(model){ (index: Int, field : String, value : Any) -> () in
                println("type:\(value.dynamicType), index: \(index), field: \(field), value: \(value)")
                if let stringValue = value as? String {
                    fields[field] = self.createTextField(field, text: stringValue)
                }
            }
            return fields
        }
    }
    
    public let delegate: ModelFormDelegate
    public let model: Any
    public let modelFormActor: ModelFormActor
    private let modelMirror: MirrorType!
    
    public init(model: Any, delegate: ModelFormDelegate, actor: ModelFormActor = ModelFormViewController()) {
        self.model = model
        self.delegate = delegate
        self.modelFormActor = actor
        self.modelMirror = reflect(model)
        self.modelFormActor.setModel(self.model, andModelForm: self)
        
    }
    
}