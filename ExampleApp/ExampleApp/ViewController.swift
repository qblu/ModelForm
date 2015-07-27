//
//  ViewController.swift
//  ExampleApp
//
//  Created by Rusty Zarse on 7/25/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//

import UIKit
import ModelForm

class ViewController: UIViewController {

    // initialize in init
    var formUIViewController: UIViewController!
    
    let jackalope = Jackalope(
        catchPhrase: "Fastasfastcanbe",
        contrived: true,
        awesomenessScore: Int.max
    )
    
    required init(coder aDecoder: NSCoder) {
        
        super.init(coder:aDecoder)
        
        // ready to use self
        formUIViewController = setupModelFormViewController()
        self.addChildViewController(formUIViewController)
    }
    
    func setupModelFormViewController() -> UIViewController {
    
        
        let modelFormDelegate = ExampleModelFormDelegate()
        let modelForm = ModelForm(model:jackalope, delegate: modelFormDelegate, modelAdapter:JackalopeModelAdapter())
        
        var modelFormViewController: UIViewController
        
        if let formController = modelForm.formController as? UIViewController {
            return formController
        } else {
            // something went wrong code
            println("OMG!  This is totally not expected!  The formController is no viewController")
            let handleTheFailViewController = UIViewController()
            let label = UILabel(frame: CGRectMake(0, 0, 300, 40))
            label.text = "Sorry, ModelForm Failed to load a form view controller"
            handleTheFailViewController.view.addSubview(label)
            return handleTheFailViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(formUIViewController.view)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

