//
//  RiderHistoryViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import RealmSwift

class DriverHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var driverID = ""
    var pastLocations: [String:[[String:Any]]]?
    
    
    @IBOutlet weak var paymentHistoryLabel: UILabel!
    @IBOutlet weak var rideHistoryLabel: UILabel!
    @IBOutlet weak var historyItem: UINavigationItem!
    @IBOutlet weak var paymentsHistory: UITableView!
    @IBOutlet weak var rideHistory: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("history", comment: "")
        rideHistoryLabel.text = NSLocalizedString("rideHistory", comment: "")
        paymentHistoryLabel.text = NSLocalizedString("paymentHistory", comment: "")
        
        paymentsHistory.delegate = self
        paymentsHistory.dataSource = self
        
        rideHistory.delegate = self
        rideHistory.dataSource = self
        
        let realm = try! Realm()
        let driver = realm.objects(Driver.self).first
        driverID = driver!.driver_id
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Function to load the data from the url
    override func viewWillAppear(_ animated: Bool) {
        // Create the URLSession object that will be used to make the requests
        let mySession: URLSession = URLSession.shared
        
        // Create a url set to the desired server address
        let myUrl: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-history/driver?id=\(driverID)")!
        
        // Create the request object passing it the url object
        var myURLRequest: URLRequest = URLRequest(url: myUrl)
        
        myURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        // Create a task from the session by passing in your request, and the callback handler
        let myTask = mySession.dataTask(with: myURLRequest, completionHandler: requestTask )
        
        // Tell the task to run
        myTask.resume()
    }
    
    // Define a function that will handle the request, and if there are no errors display the data
    func requestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError:Error?) -> Void {
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            self.myCallBack(responseString: "", error: serverError?.localizedDescription)
        }
        else {
            // Stringfy the response data
            let result = String(data: serverData!, encoding: String.Encoding.utf8)!
            // Send the response string data, and nil for the error tot he callback
            self.myCallBack(responseString: result as String, error:nil)
        }
    }
    
    // Define the callback function to be triggered when the response is recieved
    func myCallBack(responseString: String, error: String?) {
        // If the server request generated an error then handle it
        if error != nil {
            print("ERROR is " + error!)
        }else{
            // Else take the data recieved from the server and process it
            print(responseString)
            // Take the response string and turn it back into raw data
            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    // Try to convert response data into a dictionary to be save into the jsonDictionary optional dictionary variable
                    pastLocations = try JSONSerialization.jsonObject(with: myData, options: []) as? [String:[[String:Any]]]
                    
                    
                    // This callback is run on a secondary thread, so you must make any UI updates on the main thread by calling the DispatchQueue.main.async() method
                    DispatchQueue.main.async() {
                        //self.paymentsHistory.reloadData()
                        self.rideHistory.reloadData()
                    }
                    
                } catch let convertError {
                    // If it fails catch the error info
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows depending on the length of the jsonDictionary
        if let dictionary = pastLocations {
            return dictionary.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rideHistory.dequeueReusableCell(withIdentifier: "rideHistoryCell")! as UITableViewCell
        let history = pastLocations!["history"]!
        let riderDate = history[indexPath.row]["ride_date"]!
        cell.textLabel?.text = "\(String(describing: riderDate))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showHistoryDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showHistoryDetails" {
            //Get the IndexPath of the selected cell in the row when you tap it
            let index: IndexPath = rideHistory.indexPathForSelectedRow!
            
            // Get the new view controller using segue.destination.
            let nextView = segue.destination as! DriverDetailsFeedabackViewController
            
            let history = pastLocations!["history"]!
            nextView.riderInfo = history[index.row]["rider_info"] as? [String : Any]
            nextView.rideDate = history[index.row]["ride_date"] as? String
            print()
        }
    }
}
