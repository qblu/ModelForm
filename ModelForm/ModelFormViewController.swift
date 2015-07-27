//
//  ModelFormViewController.swift
//  ModelForm
//
//  Created by Rusty Zarse on 7/27/15.
//  Copyright (c) 2015 LeVous. All rights reserved.
//


class ModelFormViewController: UIViewController, ModelFormController {
    
    private var modelForm: ModelForm!
    private var model: Any!
    private var formFields: [String: UIControl]!
    private var labels: [String: UILabel]!
    private var saveButton: UIButton!
    private var cancelButton: UIButton!
    
    //MARK: ModelFormController Protocol
    
    func setModel(model: Any, andModelForm modelForm: ModelForm) {
        self.model = model
        self.modelForm = modelForm
        
        formFields = createFormFieldsForModel(modelForm.modelPropertyMirrorMap)
        labels = createLabelsForFormFields(formFields)
        createButtonsForForm()
    }
    
    func setFormPropertyValue(value:Any, forPropertyNamed name: String) {
        if let formField = formFields[name] {
            if var textField = formField as? UITextField, textValue = value as? String {
                (formFields[name] as! UITextField).text = textValue
                Logger.logVerbose(textField.debugDescription)
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
            Logger.logVerbose("name: \(name) is \(formField)")
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
        self.modelForm.delegate.modelForm(self.modelForm, didSaveModel: updatedModel, fromModelFormController: self)
    }
    
    //MARK: UIViewController Lifecycle
    
    override func loadView() {
        
        view = UIView(frame: UIScreen.mainScreen().applicationFrame)
        //view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addControlsToView()
        addLabelsToView()
        addButtonsToView()
        buildAutoLayoutConstraints()
        
    }
    
    func addControlsToView() {
        for (name, control) in formFields {
            //Coloring
            control.backgroundColor = UIColor(red: 135/255, green: 222/255, blue: 212/255, alpha: 1)
            // add to the view
            view.addSubview(control)
        }
    }
    
    func addLabelsToView() {
        for (name, label) in labels {
            //Coloring
            label.backgroundColor = UIColor(red: 255/255, green: 222/255, blue: 212/255, alpha: 1)
            
            // add to the view
            view.addSubview(label)
        }
    }
    
    func addButtonsToView() {
        saveButton.backgroundColor = UIColor.greenColor()
        cancelButton.backgroundColor = UIColor.redColor()
        view.addSubview(cancelButton)
        view.addSubview(saveButton)
    }
    
    func saveButtonTapped(sender:UIButton!) {
        self.saveFormToModel()
    }
    
    func cancelButtonTapped(sender:UIButton!) {
        // primitive but gets the job done
        for subView in self.view.subviews {
            subView.removeFromSuperview()
        }
        self.loadView()
    }
    
    func buildAutoLayoutConstraints() {
        //TODO: map the dicitonary into an array of fields
        
        let metrics = [
            "topGuide": 20, //topLayoutGuide.length,
            "bottomGuide": bottomLayoutGuide.length,
            "verticalFieldMargin": 10,
            "verticalLabelToFieldMargin": 5
        ]
        
        // |-(==padding)-[imageView]->=0-[button]-(==padding)-|
        var verticalLayoutAscii = "V:|-topGuide-"
        let verticalLayoutClose = "|"
        var verticalConstraintViews = [String: UIView]()
        // Vertical constraints string pattern
        for (name, control) in formFields {
            
            // find the label for this control
            if let label = labels[name] {
                label.setTranslatesAutoresizingMaskIntoConstraints(false)
                // append format for label to vertical constraint string
                verticalLayoutAscii += "[label_" + name + "(24)]-(==verticalLabelToFieldMargin)-"
                // add to views for vertical layout constraint
                verticalConstraintViews["label_" + name] = label
                // horizontal constraint for label
                let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                    "H:|[" + name + "]-|",
                    options: NSLayoutFormatOptions.allZeros,
                    metrics: metrics, views: [name: label]
                )
            }
            
            // layout form field
            control.setTranslatesAutoresizingMaskIntoConstraints(false)
            // append format for label to vertical constraint string
            verticalLayoutAscii += "[field_" + name + "(26)]-(>=verticalFieldMargin)-"
            // add to views for vertical layout constraint
            verticalConstraintViews["field_" + name] = control
            // horizontal constraint for form field
            let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[" + name + "]-|",
                options: NSLayoutFormatOptions.allZeros,
                metrics: metrics, views: [name: control]
            )
            
            
            NSLayoutConstraint.activateConstraints(horizontalConstraints)
            
        }
        
        // buttons constraints
        cancelButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        saveButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        Logger.logVerbose("\(saveButton)")
        let horizontalButtonConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[cancelButton]-[saveButton]-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: metrics,
            views: ["cancelButton": cancelButton, "saveButton": saveButton]
        )
        
        
        NSLayoutConstraint.activateConstraints(horizontalButtonConstraints)

        
        let saveButtonHeightConstraint = NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[saveButton(==44)]",
            options: NSLayoutFormatOptions.AlignAllCenterY,
            metrics: metrics,
            views: ["saveButton":saveButton]
        )
        
        NSLayoutConstraint.activateConstraints(saveButtonHeightConstraint)

        
        verticalLayoutAscii += "[cancelButton(==saveButton)]-(>=verticalFieldMargin)-"
        verticalConstraintViews["cancelButton"] = cancelButton
        verticalConstraintViews["saveButton"] = saveButton
        
        verticalLayoutAscii += verticalLayoutClose
        
        // Vertical constraints
        Logger.logVerbose(verticalLayoutAscii)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(verticalLayoutAscii, options: NSLayoutFormatOptions.allZeros, metrics: metrics, views: verticalConstraintViews)
        NSLayoutConstraint.activateConstraints(verticalConstraints)
    }
    
    //MARK: UI Setup
    
    func createTextField(fieldName: String, text: String) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.placeholder = modelForm.titlizeText(fieldName)
        return textField
    }
    
    
    func createFormFieldsForModel( reflectedPropertyMap: [String: ModelForm.ModelPropertyMirror] ) -> [String: UIControl] {
        var fields = [String: UIControl]()
        
        for (proeprtyName, mirror) in reflectedPropertyMap {
            Logger.logVerbose("type:\(mirror.value.dynamicType), index: \(mirror.propertyIndex), field: \(mirror.name), value: \(mirror.value)")
            if let stringValue = mirror.value as? String {
                fields[mirror.name] = self.createTextField(mirror.name, text: stringValue)
            }
        }
        return fields
    }
    
    func createLabelsForFormFields(formFields: [String: UIControl]) -> [String: UILabel] {
        var labels = [String: UILabel]()
        for (name, formField) in formFields {
            let label = UILabel()
            label.text = modelForm.titlizeText(name)
            labels[name] = label
        }
        return labels
    }
    
    func createButtonsForForm() {
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "cancelButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        saveButton = UIButton()
        saveButton.setTitle("Save", forState: UIControlState.Normal)
        saveButton.addTarget(self, action: "saveButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    }
}