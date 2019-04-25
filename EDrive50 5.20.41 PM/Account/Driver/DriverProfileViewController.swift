//
//  RiderProfileViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import RealmSwift

class DriverProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var change: UIButton!
    @IBOutlet weak var profileItem: UINavigationItem!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var driverImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var yourRating: UILabel!
    @IBOutlet weak var availabilitySwitch: UISwitch!
    
    
    var imagePicker = UIImagePickerController()
    var RiderAccountOptions = [String]()
    var segueIdentifiers = ["showVehicleDetails","showChangeAccessibilityOptions","showChangeEmail","showChangePassword"]
    var rating = 0
    var starArray = [UIImageView]()
    var availability = true
    var driverId:String?
    var driver: Driver?
    var driverAvailable : Bool?
//    let userDefaults = UserDefaults()
     let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.restoreAvailability()
        RiderAccountOptions = [NSLocalizedString("vehicleDetails", comment: ""), NSLocalizedString("accessibilityOptions", comment: ""), NSLocalizedString("changeEmail", comment: ""), NSLocalizedString("changePassword", comment: "")]
        
        self.title = NSLocalizedString("profile", comment: "")
        yourRating.text = NSLocalizedString("yourRating", comment: "")
        change.setTitle(NSLocalizedString("change", comment: ""), for: .normal)
        
        
       
        driver = realm.objects(Driver.self).first
        driverName.text = driver?.name
        driverId = driver?.driver_id
        driverAvailable = driver?.is_available
        starArray = [star1, star2, star3, star4, star5]
        
    
        print(driverAvailable!)
        self.availabilitySwitch.setOn(driverAvailable!, animated: true)
        
        let num = rating - 1
        if(num > 0){
            for index in 0...num {
                starArray[index].image = UIImage(named: "FilledStar.png")
            }
        }
        
        availabilitySwitch.addTarget(self, action: #selector(valueChange), for:UIControl.Event.valueChanged)
        
    }
    
    @objc func valueChange(mySwitch: UISwitch) {
        let value = mySwitch.isOn
        availability = value

        changeAvailability()
    }

    func changeAvailability(){
      
        print("called")
            let driverRequestURL: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/driver/availability")!
            var driverRequestURLRequest: URLRequest =  URLRequest(url: driverRequestURL);
            driverRequestURLRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            driverRequestURLRequest.httpMethod = "PUT"
            let valueString = "id=\(driverId!)&available=\(availability)"
            driverRequestURLRequest.httpBody = valueString.data(using: .utf8)
            
            let driverRequestSession: URLSession = URLSession.shared
            // creating task object from the session by passing in request and the completion handler
            let driverTask = driverRequestSession.dataTask(with: driverRequestURLRequest, completionHandler: driverRequestTask )
            
            //executing task
            driverTask.resume()
    }
    
    
    func driverRequestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            self.driverRequestCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        } else {
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            self.driverRequestCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
        }
        
    }
    
    func driverRequestCallBack(responseString:String, error:String?) {
        
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            print(responseString)
            
            }
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
            }
        }
    
    
    @IBAction func changePhoto(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            driverImage.image = image
            print(image) //get the path to save in database
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RiderAccountOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")! as UITableViewCell
        cell.textLabel?.text = RiderAccountOptions[indexPath.row]
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
    }
}
