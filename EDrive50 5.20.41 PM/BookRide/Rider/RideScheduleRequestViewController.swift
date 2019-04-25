//
//  RideScheduleRequestViewController.swift
//  edrive50
//
//  Created by Oluwakemi Mafe on 2019-04-05.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import UserNotifications

class RideScheduleRequestViewController: UIViewController {

    @IBOutlet weak var pickupAddress: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var pickupTimeAndDate: UILabel!
    @IBOutlet weak var wheelchairBox: CheckmarkButton!
    @IBOutlet weak var bigTrunkBox: CheckmarkButton!
    @IBOutlet weak var physicalAssistanceBox: CheckmarkButton!
    @IBOutlet weak var otherBox: CheckmarkButton!
    @IBOutlet weak var confirmationView: UIView!
    @IBOutlet weak var confirmationMessage: UILabel!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var physicalLabel: UILabel!
    @IBOutlet weak var bigTrunkLabel: UILabel!
    @IBOutlet weak var wheelLabel: UILabel!
    @IBOutlet weak var scheduleBtn: UIButton!
    @IBOutlet weak var SpecialLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var destinationlabel: UILabel!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var accessibilityItem: UINavigationItem!
    
    var placeA : Place?
    var placeB : Place?
    var wheelchair: Bool?
    var bigTrunk: Bool?
    var physicalAssistance: Bool?
    var date : Int64?
    var rideTime:Date?
    var time:String?
    var other: Bool?
    var requestJsonObject : [String:Any]?
    var rideInfo : [String:Any]?
    var startAdr:[String:Any]?
    var endAdr:[String:Any]?
    var accessibility:[String:Any]?
   
    override func viewDidLoad() {
        super.viewDidLoad()
    print("testinnnnnnng")
        self.title = NSLocalizedString("accessible", comment: "")
        pickUp.text = NSLocalizedString("pickUp", comment: "")
        destinationlabel.text = NSLocalizedString("destination", comment: "")
        timeLabel.text = NSLocalizedString("time", comment: "")
        wheelLabel.text = NSLocalizedString("wheelchair", comment: "")
        physicalLabel.text = NSLocalizedString("physical", comment: "")
        SpecialLabel.text = NSLocalizedString("Special", comment: "")
        otherLabel.text = NSLocalizedString("other", comment: "")
        bigTrunkLabel.text = NSLocalizedString("trunk", comment: "")
        scheduleBtn.setTitle(NSLocalizedString("scheduleBtn", comment: ""), for: .normal)
        
        pickupAddress.text = placeA?.address
        destination.text = placeB?.address
        pickupTimeAndDate.text = time
        confirmationView.isHidden = true
        confirmationView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8/1)
        confirmationMessage.isHidden = true
        confirmationMessage.text =  NSLocalizedString("rideRequest", comment: "") + "\n" + NSLocalizedString("scheduled", comment: "") + "\n" + NSLocalizedString("successfully", comment: "")
      
        let realm = try! Realm()
        let r = realm.objects(Rider.self).first
        wheelchairBox.setChecked(r!.wheelchair)
        bigTrunkBox.setChecked(r!.big_truck)
        physicalAssistanceBox.setChecked(r!.physical_assistance)
        otherBox.setChecked(false)
        
        
        let content = UNMutableNotificationContent()
        content.title = "Scheduled Ride"
        content.body = "Find a Driver for your scheduled ride"
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  toSecs(date: rideTime!), repeats: false)
        
        let request = UNNotificationRequest(identifier: "schedule", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func toSecs(date: Date)-> Double!{
        return (Double(date.timeIntervalSince1970) - 600.0)
    }
    
    @IBAction func scheduleRequestBtnAction(_ sender: Any) {
        
        wheelchair = wheelchairBox.isChecked()
        bigTrunk = bigTrunkBox.isChecked()
        physicalAssistance = physicalAssistanceBox.isChecked()
        other = otherBox.isChecked()
        
        //send request to database for later time
        
        confirmationView.isHidden = false
        scheduleRequest()
        
    }
    
    func scheduleRequest(){
        var riderObj : [String:Any]? = [:]
        rideInfo = [:]
        startAdr  = [:]
        endAdr  = [:]
        accessibility  = [:]
        print(placeB!.points.latitude)
      
        
        startAdr!["street_num"] = placeA!.street_number!
        startAdr!["street"] = placeA!.street_name!
        startAdr!["city"] = placeA!.city!
        startAdr!["prov"] = placeA!.prov!
        startAdr!["postal_code"] = placeA!.postal_code!
        startAdr!["latitude"] = placeA!.points.latitude
        startAdr!["longitude"] = placeA!.points.longitude
        
        endAdr!["street_num"] = placeB!.street_number!
        endAdr!["street"] = placeB!.street_name!
        endAdr!["city"] = placeB!.city!
        endAdr!["prov"] = placeB!.prov!
        endAdr!["postal_code"] = placeB!.postal_code!
        endAdr!["latitude"] = placeB!.points.latitude
        endAdr!["longitude"] = placeB!.points.longitude
        
        let realm = try! Realm()
        let rider = realm.objects(Rider.self).first
        
        accessibility!["wheelchair"] = wheelchair
        accessibility!["physical_assistance"] = physicalAssistance
        accessibility!["big_trunk"] = bigTrunk
        accessibility!["other_details"] = ""
        
        
        rideInfo!["rider_name"] = rider?.name
        rideInfo!["rider_image"] = rider?.image
        rideInfo!["start_address"] = startAdr
        rideInfo!["end_address"] = endAdr
        rideInfo!["accessibility_options"] = accessibility
        
        riderObj!["rider_id"] = rider?.rider_id
        riderObj!["chosen_driver_id"] = "[N/A]"
        riderObj!["ride_time"] = date
        riderObj!["rider_info"] = rideInfo
        
        let localRideObject = rideInfo
        let rideInformation = RideInfo()
        
        
        let info = rideInformation.makeRideInfo(obj: localRideObject, notificationId: "scheduled")
        
            rideInformation.save(rideInfo: info)
        
        do {
            let rideRequestURL: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/")!
            var rideURLRequest: URLRequest =  URLRequest(url: rideRequestURL);
            rideURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //        driverRequestURLRequest.httpBody = driverId
            rideURLRequest.httpMethod = "POST"

            let riderData = try JSONSerialization.data(withJSONObject: riderObj as Any, options: [])
            rideURLRequest.httpBody = riderData

            let rideScheduleSession: URLSession = URLSession.shared
            // creating task object from the session by passing in request and the completion handler
            let rideTask = rideScheduleSession.dataTask(with: rideURLRequest, completionHandler: rideRequestTask )

            //executing task
            rideTask.resume()
            } catch {
            //outputting error if error occurs
            print ("Coverted error = \(error.localizedDescription)")
            }
        //creating Session using shared session

        }
    
    func rideRequestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            self.rideScheduleCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        } else {
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            self.rideScheduleCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
        }
    }
    
    func rideScheduleCallBack(responseString:String, error:String?) {
        
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            print(responseString)
            
            //converting json string to data
            if let driverData:Data = responseString.data(using: String.Encoding.utf8){
                //                print(driverData)
                do {
                    //converting data to json object and storing it in jsonObject
                    
                    requestJsonObject = try (JSONSerialization.jsonObject(with: driverData, options: []) as? [String:Any])
                } catch let convertError {
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                self.loading.isHidden = true
                self.confirmationMessage.isHidden = false
                let when = DispatchTime.now() + 5
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
               
            }
        }
    }
    
    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
*/

