//
//  RiderRegisterPayOptionsViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift

class RiderRegisterPayOptionsViewController: ViewController {

    @IBOutlet weak var skip: UIButton!
    @IBOutlet weak var addPayment: UIButton!
    @IBOutlet weak var finalizeItem: UINavigationItem!
    
    var riderInfo: RiderInfo?
    let POSTURL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/register/rider")!
    
    @IBAction func PaymentMethod(_ sender: Any) {
        //version 2
    }
    @IBAction func SkipButton(_ sender: Any) {
        let postBody = "name=\(String(describing: riderInfo!.name!))&email=\(String(describing: riderInfo!.emailaddress!))&password=\(riderInfo!.password!)&phone_number=\(riderInfo!.phoneNumber!)&emergency_name=\(riderInfo!.emergencyName!)&emergency_number=\(riderInfo!.emergencyNumber!)&wheelchair=\(riderInfo!.wheelChair!)&physical_assistance=\(riderInfo!.physicalAssistance!)&big_truck=\(riderInfo!.bigTruck!)&other_details=\(riderInfo!.other!)".data(using: .utf8)
        
        var POSTrequest = URLRequest(url: POSTURL)
        POSTrequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        POSTrequest.httpMethod = "POST"
        
        //FIX THIS
        //let postString = "email=\(String(describing: email))&password=\(String(describing: pass))" // which is your parameters
        POSTrequest.httpBody = postBody
        
        let POSTtask = URLSession.shared.dataTask(with: POSTrequest, completionHandler: requestTask);
        POSTtask.resume()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("finalize", comment: "")
        addPayment.setTitle(NSLocalizedString("addPayment", comment: ""), for: .normal)
        skip.setTitle(NSLocalizedString("skip&finish", comment: ""), for: .normal)
    }
    
    func requestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError:Error?) -> Void {
        print("here")
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            
            self.POSTCallBack(responseString: "", error: serverError?.localizedDescription)
        }
        else {
            // Stringfy the response data
            
            let result = String(data: serverData!, encoding: String.Encoding.utf8)!
            // Send the response string data, and nil for the error tot he callback
            self.POSTCallBack(responseString: result as String, error:nil)
        }
    }
    
    // Define the callback function to be triggered when the response is recieved
    func POSTCallBack(responseString: String, error: String?) {
        // If the server request generated an error then handle it
        if error != nil {
            print("ERROR is " + error!)
        } else {
            // Else take the data recieved from the server and process it
            // Take the response string and turn it back into raw data
            // Convert server json response to NSDictionary

            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    let obj = try JSON(data: myData)
                    
                    let r = Rider()
                    let rider = r.makeRider(obj: obj, token: obj["token"].string!, language: "En")
                    
                    if r.count() > 0 {
                        r.delete(rider: rider)
                        r.save(rider: rider)
                    } else {
                        r.save(rider: rider)
                    }
                } catch let convertError {
                    // If it fails catch the error info
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SkipRegisterPaymentSegue" {
            let loginSplashController = segue.destination as? LoginSplashScreenViewController
            print("name! : \((riderInfo?.name)!)")
            loginSplashController?.name = (riderInfo?.name)!
            loginSplashController?.userType = "Rider"
        } else if segue.identifier == "RegisterPaymentSegue" {
            let paymentController = segue.destination as? RiderRegisterPaymentViewController
            paymentController?.riderInfo = riderInfo
        }
    }

}
