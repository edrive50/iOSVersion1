//
//  VehicleRegistrationViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-23.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import SQLite3

class VehicleRegistrationViewController: ViewController,  UITextFieldDelegate {
    var driverInfo : DriverInfo?
    var driverjson : [String: Any] = [:]
    var car_details : [String: Any] = [:]
    var registration_details : [String: Any] = [:]
    var accessibility_options : [String: Any] = [:]
    var driverData: Data?
    
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var licenseLabel: UILabel!
    @IBOutlet weak var regName: UILabel!
    @IBOutlet weak var required: UILabel!
    @IBOutlet weak var registration: UINavigationItem!
    @IBOutlet weak var vehicleReg: UILabel!
    @IBOutlet weak var registeredNameField: UITextField!
    @IBOutlet weak var VINField: UITextField!
    @IBOutlet weak var licensePlateField: UITextField!
    
    var registeredName: String?
    var vin: String?
    var license: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("registration", comment: "")
        finish.setTitle(NSLocalizedString("finish", comment: ""), for: .normal)
        regName.text = NSLocalizedString("registeredName", comment: "")
        required.text = NSLocalizedString("required", comment: "")
        vehicleReg.text = NSLocalizedString("vehicleReg", comment: "")
        licenseLabel.text = NSLocalizedString("license", comment: "")
        
        licensePlateField.delegate = self
    }
    
    @IBAction func FinishButton(_ sender: Any) {
        registeredName = registeredNameField.text!
        vin = VINField.text!
        license = licensePlateField.text!
        
        driverjson["name"] = driverInfo!.name
        driverjson["email"] = driverInfo!.emailaddress
        driverjson["password"] = driverInfo!.password
        driverjson["phone_number"] = driverInfo!.phoneNumber
        driverjson["image"] = "[[image]]"
        driverjson["rating"] = 0
        driverjson["user_description"] = driverInfo!.description
        
        car_details["model"] = driverInfo!.vehicleModel
        car_details["make"] = driverInfo!.vehicleMake
        car_details["colour"] = driverInfo!.vehicleColour
        car_details["type"] = driverInfo!.vehicleType
        car_details["year"] = driverInfo!.vehicleYear
        
        registration_details["registered_name"] = registeredName
        registration_details["licence_plate"] = license
        registration_details["vin"] = vin
        
        car_details["registration_details"] = registration_details
        
        accessibility_options["wheelchair"] = driverInfo!.wheelChair
        accessibility_options["physical_assistance"] = driverInfo!.physicalAssistance
        accessibility_options["big_truck"] = driverInfo!.bigTruck
        accessibility_options["other_details"] = driverInfo!.other
        car_details["accessibility_options"] = accessibility_options
        
        driverjson["car_details"] = car_details
        
        do {
            
            driverData = try JSONSerialization.data(withJSONObject: driverjson, options: [])

            let driverURL: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/register/driver")!
            
            //creating url request
            var driverURLRequest: URLRequest =  URLRequest(url: driverURL);
            driverURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            driverURLRequest.httpBody = driverData
            driverURLRequest.httpMethod = "POST"
            
            //creating Session using shared session
            let driverSession: URLSession = URLSession.shared
            
            // creating task object from the session by passing in request and the completion handler
            let driverTask = driverSession.dataTask(with: driverURLRequest, completionHandler: requestTask )
            
            //executing task
            driverTask.resume()
        }
        catch {
            //outputting error if error occurs
            print ("Coverted error = \(error.localizedDescription)")
        }
        
    }
    
    func requestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            self.callBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        } else {
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            self.callBack(responseString: response as String, error: nil) //sending response string if there are no errors
        }
    }
    
    func callBack(responseString:String, error:String?) {
        
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            print(responseString)
            
                }
    }

    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        registeredNameField.resignFirstResponder()
        VINField.resignFirstResponder()
        licensePlateField.resignFirstResponder()
        return false
    }

}
