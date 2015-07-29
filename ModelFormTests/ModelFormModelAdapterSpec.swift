//
//  ModelFormModelAdapterSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/28/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Quick
import Nimble
import ModelForm

struct DogModelAdapter: ModelFormModelAdapter {
    func initializeModel(modelProperties:[String: ModelForm.ModelPropertyMirror]) -> (validationResult:ModelFormValidationResult, value: Any) {
        
        let newDog = Dog(
            // implicit unwraps are ok here because each "value" was refected from an instance of this type.
            breed: modelProperties["breed"]!.value as! String,
            heightInInches: modelProperties["heightInInches"]!.value as! Int,
            profilePhotoUrl: (modelProperties["profilePhotoUrl"]!.value as? NSURL),
            willBiteYou: (modelProperties["willBiteYou"]!.value as! Bool)
        )
        return (ModelFormValidationResult.validResult(), newDog)
    }
}


class ModelFormModelAdapterSpec: QuickSpec {
    
    func makeDog() -> Dog {
        let dog = Dog(
            breed: "Laborador",
            heightInInches: 32,
            profilePhotoUrl: NSURL(string: "http://cdn.akc.org/akcdoglovers/LabradorRetriever_hero.jpg")!,
            willBiteYou: false
        )
        return dog
    }
    
    override func spec() {
        
        beforeEach { /* Executes before each test and prior to nested beforeEach */ }
        
        describe(".initializeModel") {
        
            context("When modelProperties contains valid data") {
                beforeEach { }
                it("returns a valid value") {
                    let modelForm = ModelForm(model: self.makeDog(), delegate: TestDogDelegate(), modelAdapter: DogModelAdapter())
                    let validationResult = modelForm.formController.setFormPropertyValue("77", forPropertyNamed: "heightInInches")
                    
                    expect(validationResult.valid).to(beTrue())
                    expect(validationResult.findValidationItemWithName("heightInInches")).to(beNil())

                }
            }
        
            context("When modelProperties contains invalid data") {
                beforeEach { }
                it("returns a partially updated model with validation information") {
                    let modelForm = ModelForm(model: self.makeDog(), delegate: TestDogDelegate(), modelAdapter: DogModelAdapter())
                    let validationResult = modelForm.formController.setFormPropertyValue("Not OK", forPropertyNamed: "heightInInches")
                    expect(validationResult.valid).to(beFalse())
                    expect(validationResult.findValidationItemWithName("heightInInches")).notTo(beNil())
                    
                }
            }
        }
    }
}



