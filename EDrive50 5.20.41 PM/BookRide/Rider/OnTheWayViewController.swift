//
//  OnTheWayViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-28.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class OnTheWayViewController: UIViewController {
    
    @IBOutlet weak var DriverName: UILabel!
    @IBOutlet weak var onTheWay: UILabel!
    @IBOutlet weak var requestItem: UINavigationItem!
    
    var driverNameText : String?
    var riderNameText: String?
    var driver_id:String?
    var messageURL: URL?
    var ride_id:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("request", comment: "")
       
        onTheWay.text = NSLocalizedString("onTheWay", comment: "")
        
         DriverName.text = driverNameText
        let number = "7802887240"
        let originalString = "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/family-contact/message/?number=\(number)&rider=\(riderNameText!)&driver=\(driverNameText!)"
        
        let urlString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        messageURL = URL(string: urlString!)!
        // creating request using url
        
        var responseURLRequest: URLRequest = URLRequest(url: messageURL!)
        responseURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //creating Session using shared session
        let responseSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let responseTask = responseSession.dataTask(with: responseURLRequest, completionHandler: smsRequestTask )
        
        //executing task
        responseTask.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func smsRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.callback(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.callback(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func callback(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        } else {
            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8) {
                
                do{
                   
                } catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                
                let when = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.performSegue(withIdentifier: "MapAndSearchSegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mapVC = segue.destination as! MapAndSearchViewController
        mapVC.isBooked = true
        mapVC.driver_id = driver_id
        mapVC.driver_name = driverNameText
        mapVC.ride_id = ride_id
    }


}
