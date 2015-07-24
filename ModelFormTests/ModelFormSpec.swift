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
            
            func modelForm(modelForm: ModelForm, didSaveModel model: Any, fromModelFormActor modelFormActor: ModelFormActor) {
                self.model = model
                if let modelFormViewController = modelFormActor as? UIViewController {
                    self.viewController = modelFormViewController
                }
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
                    let modelForm = ModelForm(model:dog, delegate: testDelegate)
                    let modelFormActor = modelForm.modelFormActor
                    
                    
                    modelFormActor.saveFormToModel()
                    // ensure the test delegate got what it expected
                    expect(testDelegate.model).toNot(beNil())
                    expect(testDelegate.viewController).toNot(beNil())

                    // check the new dog
                    if let dog2 = testDelegate.model as? Dog {
                        expect(dog2.breed).to(equal("German Shepherd"))
                    } else {
                        fail("didn't get a new dog.  boo!")
                    }
                    
                    
                    // ensure the viewController does the right stuff, too
                    if let viewController = testDelegate.viewController {
                        (viewController as! ModelFormActor).setFormPropertyValue("Mutt", forPropertyNamed:"breed")
                    } else {
                        fail("couldn't get the viewController")
                    }
                    
                    
                
                    
                    
                    
                    
                    
                    
                }
            }
        
            
        }
    }
}

