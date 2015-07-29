//
//  JackalopeModelAdapter.swift
//  ExampleApp
//
//  Created by Rusty Zarse on 7/25/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import ModelForm
struct JackalopeModelAdapter: ModelFormModelAdapter {
    func initializeModel(modelProperties:[String: ModelForm.ModelPropertyMirror]) -> (validationResult:ModelFormValidationResult, value: Any) {
        let newJackalope = Jackalope(
            // implicit unwraps are ok here because each "value" was refected from an instance of this type.
            catchPhrase: modelProperties["catchPhrase"]!.value as! String,
            contrived: modelProperties["contrived"]!.value as! Bool,
            awesomenessScore: (modelProperties["awesomenessScore"]!.value as! Int)
        )
        return (ModelFormValidationResult.validResult(), newJackalope)
    }
}
