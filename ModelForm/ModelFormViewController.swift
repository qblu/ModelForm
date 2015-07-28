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
    private var formFieldFactory: FormFieldFactory = PropertyTypeFormFieldFactory()
    private var propertyTypeFormFields: [String: PropertyTypeFormField]!
    private var formFields: [String: UIControl]!
    private var labels: [String: UILabel]!
    private var saveButton: UIButton!
    private var cancelButton: UIButton!
    
    //MARK: ModelFormController Protocol
    func setModel(model: Any, andModelForm modelForm: ModelForm) {
        self.model = model
        self.modelForm = modelForm
        propertyTypeFormFields = createPropertyTypeFormFields(modelForm.modelPropertyMirrorMap)
        formFields = createFormFieldsForModel(modelForm.modelPropertyMirrorMap)
        labels = createLabelsForFormFields(formFields)
        createButtonsForForm()
    }
    
    func setFormPropertyValue(value:Any, forPropertyNamed name: String) {
        if let formField = formFields[name], propertyTypeField = propertyTypeFormFields[name] {
            if(!propertyTypeField.updateValue(value, onFormField:formField)) {
                Logger.logWarning("Form field could not update value [\(value)] for property named:\(name)")
            }
        } else {
            Logger.logWarning("Form field or proeprtyTypeField not found for property named:\(name)")
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
            if let propTypeField = propertyTypeFormFields[name] {
                let (isValid, updatedValue) = propTypeField.getValueFromFormField(formField)
                if( isValid) {
                    Logger.logVerbose("updatedMap[ \(name) ] = \(updatedValue)")
                    updatedPropertyMap[name]!.value = updatedValue
                } else {
                    Logger.logWarning("The provided value was invalid for propety named:\(name)")
                }
            } else {
                Logger.logWarning("propertyTypeFormFields[name] failed to find a PropertyTypeFormFields for name:\(name)")
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
            //control.backgroundColor = UIColor(red: 135/255, green: 222/255, blue: 212/255, alpha: 1)
            // add to the view
            view.addSubview(control)
        }
    }
    
    func addLabelsToView() {
        for (name, label) in labels {
            //Coloring
            //label.backgroundColor = UIColor(red: 255/255, green: 222/255, blue: 212/255, alpha: 1)
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
            "verticalLabelToFieldMargin": 5,
            "horizontalMargin": 10
        ]
        
        let bottomSpacerView = UIView()
        view.addSubview(bottomSpacerView)
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-[bottomSpacerView]-|",
            options: NSLayoutFormatOptions.allZeros,
            metrics: metrics, views: ["bottomSpacerView": bottomSpacerView]
        )
        bottomSpacerView.setTranslatesAutoresizingMaskIntoConstraints(false)
        NSLayoutConstraint.activateConstraints(horizontalConstraints)

        
        var verticalConstraintViews = ["bottomSpacerView": bottomSpacerView]
        
        
        // |-(==padding)-[imageView]->=0-[button]-(==padding)-|
        var verticalLayoutAscii = "V:|-topGuide-"
        let verticalLayoutClose = "[bottomSpacerView(>=1)]-|"
        
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
                    "H:|-[" + name + "]-|",
                    options: NSLayoutFormatOptions.allZeros,
                    metrics: metrics, views: [name: label]
                )
                NSLayoutConstraint.activateConstraints(horizontalConstraints)

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
            "H:|-[cancelButton(==saveButton)]-(==horizontalMargin)-[saveButton]-|",
            options: NSLayoutFormatOptions.AlignAllCenterY,
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
    
    func createPropertyTypeFormFields(reflectedPropertyMap: [String: ModelForm.ModelPropertyMirror] ) -> [String: PropertyTypeFormField] {
        var fields = [String: PropertyTypeFormField]()
        
        for (propertyName, mirror) in reflectedPropertyMap {
            if let field = formFieldFactory.createPropertyTypeFormField(mirror.value) {
                fields[propertyName] = field
            } else {
                Logger.logWarning("Failed to create a PropertyTypeFormField for property: \(propertyName) having a type: \(mirror.value.dynamicType)")
            }
        }
        return fields
    }
    
    func createFormFieldsForModel(reflectedPropertyMap: [String: ModelForm.ModelPropertyMirror] ) -> [String: UIControl] {
        var fields = [String: UIControl]()
        
        for (propertyName, mirror) in reflectedPropertyMap {
            Logger.logVerbose("type:\(mirror.value.dynamicType), index: \(mirror.propertyIndex), field: \(mirror.name), value: \(mirror.value)")
            if let propertyTypeField = formFieldFactory.createPropertyTypeFormField(mirror.value) {
                let formField = propertyTypeField.createFormField(mirror.name, value: mirror.value)
                fields[mirror.name] = formField
            } else {
                Logger.logWarning("Failed to create a form field for property: \(propertyName) having a type: \(mirror.value.dynamicType)")
            }
        }
        return fields
    }
    func styleLabel(label: UILabel) {
        label.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
        label.textColor = UIColor.grayColor()
    }
    
    func createLabelsForFormFields(formFields: [String: UIControl]) -> [String: UILabel] {
        var labels = [String: UILabel]()
        for (name, formField) in formFields {
            let label = UILabel()
            label.text = ModelForm.titlizeText(name)
            styleLabel(label)
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