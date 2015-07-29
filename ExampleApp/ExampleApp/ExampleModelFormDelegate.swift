//
//  ExampleModelFormDelegate.swift
//  ExampleApp
//
//  Created by Rusty Zarse on 7/25/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import ModelForm

class ExampleModelFormDelegate: ModelFormDelegate {
    
    var model: Any? = nil
    var viewController: UIViewController? = nil
    var validationResult: ModelFormValidationResult? = nil
    
    func modelForm(modelForm: ModelForm, didSaveModel model: Any, fromModelFormController formController: ModelFormController) {
        self.model = model
        
        let jackalope = model as! Jackalope
        
        Logger.logVerbose("model:{ catchPhrase: \"\(jackalope.catchPhrase)\", contrived: \"\(jackalope.contrived)\", awesomenessScore: \"\(jackalope.awesomenessScore)\" }")
       
    }

    
    func modelForm(
        modelForm: ModelForm,
        didFailValidationWithResult validationResult: ModelFormValidationResult,
        fromModelFormController formController: ModelFormController
        ) {
            self.validationResult = validationResult
            if let modelFormViewController = formController as? UIViewController {
                self.viewController = modelFormViewController
            }
    }

    
}