//
//  FeedbackViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-04-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    @IBOutlet weak var Star1: StarButton!
    @IBOutlet weak var Star2: StarButton!
    @IBOutlet weak var Star3: StarButton!
    @IBOutlet weak var Star4: StarButton!
    @IBOutlet weak var Star5: StarButton!
    @IBOutlet weak var DriverNameText: UITextView!
    @IBOutlet weak var FeedbackDescription: UITextView!
    @IBOutlet weak var detailsItem: UINavigationBar!
    @IBOutlet weak var howLabel: UILabel!
    @IBOutlet weak var anySuggestions: UILabel!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var FeedBackTextArea: UITextView!
    
    var feedback_score = 0
    var ride_id: String?
    var driver_id: String?
    var driver_name: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("feeedback", comment: "")
        howLabel.text = NSLocalizedString("how", comment: "")
        anySuggestions.text = NSLocalizedString("any", comment: "")
        submitBtn.setTitle(NSLocalizedString("submit", comment: ""), for: .normal)
        
        DriverNameText.text = driver_name
        FeedBackTextArea.delegate = self
    }
    
    @IBAction func Star1(_ sender: Any) {
        Star1.fillStar()
        Star2.emptyStar()
        Star3.emptyStar()
        Star4.emptyStar()
        Star5.emptyStar()
        feedback_score = 1
    }
    
    @IBAction func Star2(_ sender: Any) {
        Star1.fillStar()
        Star2.fillStar()
        Star3.emptyStar()
        Star4.emptyStar()
        Star5.emptyStar()
        feedback_score = 2
    }
    
    @IBAction func Star3(_ sender: Any) {
        Star1.fillStar()
        Star2.fillStar()
        Star3.fillStar()
        Star4.emptyStar()
        Star5.emptyStar()
        feedback_score = 3
    }
    
    @IBAction func Star4(_ sender: Any) {
        Star1.fillStar()
        Star2.fillStar()
        Star3.fillStar()
        Star4.fillStar()
        Star5.emptyStar()
        feedback_score = 4
    }
    
    @IBAction func Star5(_ sender: Any) {
        Star1.fillStar()
        Star2.fillStar()
        Star3.fillStar()
        Star4.fillStar()
        Star5.fillStar()
        feedback_score = 5
    }

    
    @IBAction func SendButton(_ sender: Any) {
        endRide()
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        FeedBackTextArea.resignFirstResponder()
        return false
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func endRide() {
        
        let endRideURL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/rider/complete/?id=\(ride_id!)")!
        
        // creating request using url
        var endRideURLRequest: URLRequest = URLRequest(url: endRideURL)
        endRideURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        endRideURLRequest.httpMethod = "PUT"

        //creating Session using shared session
        let responseSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let responseTask = responseSession.dataTask(with: endRideURLRequest, completionHandler: endRideRequestTask )
        
        //executing task
        responseTask.resume()
    }
    
    func endRideRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.endRideCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            self.endRideCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func endRideCallBack(responseString:String, error:String?) {
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    sendFeedBack()
                } catch let convertError {
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    func sendFeedBack() {
        
        let feedbackURL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/rider/send-feedback/?id=\(driver_id!)&score=\(feedback_score)")!
        
        // creating request using url
        var feedbackURLRequest: URLRequest = URLRequest(url: feedbackURL)
        feedbackURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        feedbackURLRequest.httpMethod = "PUT"
        feedbackURLRequest.httpBody = "details=\(FeedbackDescription.text!)".data(using: .utf8)
        //creating Session using shared session
        let responseSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let responseTask = responseSession.dataTask(with: feedbackURLRequest, completionHandler: feedbackRequestTask )
        
        //executing task
        responseTask.resume()
    }
    
    func feedbackRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.feedbackCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.feedbackCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func feedbackCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        } else {
            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8){
                sendToRideHistory()
                do {
                    
                } catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    func sendToRideHistory() {
        do {
            let endRideURL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-history/")!
            
            //         creating request using url
            var historyURLRequest: URLRequest = URLRequest(url: endRideURL)
            //        historyURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            historyURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            historyURLRequest.httpMethod = "POST"
            
            var riderIdObj : [String : Any] = [:]
            riderIdObj["ride_id"] = ride_id!
            
            let riderData = try JSONSerialization.data(withJSONObject: riderIdObj, options: [])
            historyURLRequest.httpBody = riderData
            
            //creating Session using shared session
            let responseSession: URLSession = URLSession.shared
            
            // creating task object from the session by passing in request and the completion handler
            let responseTask = responseSession.dataTask(with: historyURLRequest, completionHandler: sendHistoryRequestTask )
            
            //executing task
            responseTask.resume()
            
        } catch {
            //outputting error if error occurs
            print ("Coverted error = \(error.localizedDescription)")
        }
    }
    
    func sendHistoryRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.historyCallback(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.historyCallback(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func historyCallback(responseString:String, error:String?) {
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    dismiss(animated: true, completion: nil)
                    //
                } catch let convertError {
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as! MapAndSearchViewController
        nextVC.statusUpdate.text = "Thank you for your feedback on your ride with \(driver_name!)"
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
