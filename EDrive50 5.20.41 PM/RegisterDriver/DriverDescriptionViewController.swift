//
//  DriverDescriptionViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-23.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverDescriptionViewController: ViewController,  UITextFieldDelegate, UITextViewDelegate {
    var driverInfo : DriverInfo?
    
    var desc = ""
    var makeVehicle = ""
    var modelVehicle = ""
    var typeVehicle = ""
    var colourVehicle = ""
    var yearVehicle = ""
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var briefly: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    @IBOutlet weak var VehicleMakeField: UITextField!
    @IBOutlet weak var VehicleModelField: UITextField!
    @IBOutlet weak var VehicleTypeField: UITextField!
    @IBOutlet weak var VehicleColourField: UITextField!
    @IBOutlet weak var VehicleYearField: UITextField!
    @IBOutlet weak var optional: UILabel!
    @IBOutlet weak var required: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var model: UILabel!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var colour: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var detailsItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("details", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        briefly.text = NSLocalizedString("briefly", comment: "")
        optional.text = NSLocalizedString("optional", comment: "")
        required.text = NSLocalizedString("required", comment: "")
        make.text = NSLocalizedString("make", comment: "")
        model.text = NSLocalizedString("model", comment: "")
        year.text = NSLocalizedString("year", comment: "")
        colour.text = NSLocalizedString("colour", comment: "")
        type.text = NSLocalizedString("type", comment: "")
        
        VehicleYearField.delegate = self
        descriptionField.delegate = self
    }
    
    @IBAction func NextButton(_ sender: Any) {
        desc = descriptionField.text!
        makeVehicle = VehicleMakeField.text!
        modelVehicle = VehicleModelField.text!
        typeVehicle = VehicleTypeField.text!
        colourVehicle = VehicleColourField.text!
        yearVehicle = VehicleYearField.text!
        
        driverInfo?.addCarDetails(description: desc, vehicleMake: makeVehicle, vehicleModel: modelVehicle, vehicleType: typeVehicle, vehicleColour: colourVehicle, vehicleYear: yearVehicle)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "VehicleSegue" {
            let vehicleRegistrationController = segue.destination as? VehicleRegistrationViewController
            vehicleRegistrationController?.driverInfo = driverInfo
        }
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        descriptionField.resignFirstResponder()
        VehicleMakeField.resignFirstResponder()
        VehicleModelField.resignFirstResponder()
        VehicleTypeField.resignFirstResponder()
        VehicleColourField.resignFirstResponder()
        VehicleYearField.resignFirstResponder()
        
        return true
    }
    
   
}
