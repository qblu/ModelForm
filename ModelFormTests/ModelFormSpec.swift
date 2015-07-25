//
//  ModelFormSpec.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/24/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import Foundation
import Quick
import Nimble
import ModelForm

class ModelFormSpec: QuickSpec {
    
    override func spec() {
        
        class TestDelegate: ModelFormDelegate {
            
            var model: Any? = nil
            var viewController: UIViewController? = nil
            
            func modelForm(modelForm: ModelForm, didSaveModel model: Any, fromModelFormController formController: ModelFormController) {
                self.model = model
                if let modelFormViewController = formController as? UIViewController {
                    self.viewController = modelFormViewController
                }
            }
        }
        
        struct DogModelAdapter: ModelFormModelAdapter {
            func initializeModel(modelProperties:[String: ModelForm.ModelPropertyMirror]) -> Any {
                let newDog = Dog(
                    // implicit unwraps are ok here because each "value" was refected from an instance of this type.
                    breed: modelProperties["breed"]!.value as! String,
                    heightInInches: modelProperties["heightInInches"]!.value as! Int,
                    profilePhotoUrl: (modelProperties["profilePhotoUrl"]!.value as? NSURL)
                )
                return newDog
            }
        }
        
        beforeEach { /* Executes before each test and prior to nested beforeEach */ }
        
        
        describe("createForm") {
        
            context("When provided with a valid model") {
                beforeEach { }
                it("creates a form that matches the model") {
                    // test expectations
                    let dog = Dog(
                        breed: "Laborador",
                        heightInInches: 32,
                        profilePhotoUrl: NSURL(string: "http://cdn.akc.org/akcdoglovers/LabradorRetriever_hero.jpg")!
                    )
                    
                    let testDelegate = TestDelegate()
                    let modelForm = ModelForm(model:dog, delegate: testDelegate, modelAdapter:DogModelAdapter())
                    let formController = modelForm.formController
                    
                    
                    formController.saveFormToModel()
                    // ensure the test delegate got what it expected
                    expect(testDelegate.model).toNot(beNil())
                    expect(testDelegate.viewController).toNot(beNil())
                    
                    // update the value using the actor
                    formController.setFormPropertyValue("German Shepherd", forPropertyNamed: "breed")

                    // save the change
                    formController.saveFormToModel()
                    
                    // check the new dog
                    if let dog2 = testDelegate.model as? Dog {
                        expect(dog2.breed).to(equal("German Shepherd"))
                    } else {
                        fail("didn't get a new dog.  boo!")
                    }
                    
                    
                    // ensure the viewController does the right stuff, too
                    if let viewController = testDelegate.viewController {
                        (viewController as! ModelFormController).setFormPropertyValue("Mutt", forPropertyNamed:"breed")
                        // save the change
                        (viewController as! ModelFormController).saveFormToModel()
                        expect((testDelegate.model as! Dog).breed).to(equal("Mutt"))
                    } else {
                        fail("couldn't get the viewController")
                    }
                    
                    
                
                    
                    
                    
                    
                    
                    
                }
            }
        
            
        }
        
        describe("modelAdapter") {
            context("When an adapter is provided to work with its model") {
                it("initializes a valid instance of the model") {
                    let dogAdapter = DogModelAdapter()
                    let dog = Dog(
                        breed: "Poodle",
                        heightInInches: 30,
                        profilePhotoUrl: NSURL(string: "http://www.yourpurebredpuppy.com/dogbreeds/photos-RS/standardpoodles-max.jpg")!
                    )

                    let modelForm = ModelForm(model: dog, delegate: TestDelegate(), modelAdapter:dogAdapter)
                    let properties = modelForm.modelPropertyMirrorMap
                }
            }
        }
        
        describe("modelPropertyMirror") {
            
            context("When provided with a valid model") {
                beforeEach { }
                it("creates an array of tuples describing each child property") {
                    // test expectations
                    let dog = Dog(
                        breed: "Laborador",
                        heightInInches: 32,
                        profilePhotoUrl: NSURL(string: "http://cdn.akc.org/akcdoglovers/LabradorRetriever_hero.jpg")!
                    )
                    
                    let modelForm = ModelForm(model: dog, delegate: TestDelegate(), modelAdapter:DogModelAdapter())
                    let properties = modelForm.modelPropertyMirrorMap
                    
                    var foundBreedProp = false
                    var foundHeightInInches = false
                    var foundProfilePhotoUrl = false
                    var foundSomethingElse = false
                    for (name, property) in properties {
                        switch(property.name) {
                            
                        case "breed":
                            foundBreedProp = true
                            
                        case "heightInInches":
                            foundHeightInInches = true
                            
                        case "profilePhotoUrl":
                            foundProfilePhotoUrl = true
                        
                        default:
                            // the aren't the droid's you're looking for.  You don't need to see my identification...
                            foundSomethingElse = false
                        }
                    }
                    expect(foundBreedProp).to(beTrue())
                    expect(foundHeightInInches).to(beTrue())
                    expect(foundProfilePhotoUrl).to(beTrue())
                    expect(foundSomethingElse).to(beFalse())
                }
            }
        }
    }
}

