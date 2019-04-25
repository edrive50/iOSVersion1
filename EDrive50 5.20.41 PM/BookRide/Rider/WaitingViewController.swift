//
//  WaitingViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-28.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//
import UIKit
import GoogleMaps
import SwiftyJSON
import RealmSwift

class WaitingViewController: UIViewController {
    
    private var firstLocationUpdate = false
    private var mapView: GMSMapView?
    var responseUrl: URL?
    var riderId:String?
    var timer:Timer?
    var accepted: Bool = false
    var driver_name = ""
    var rider_name = ""
    var driver_id:String?
    var ride_id:String?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var waitingResponse: UILabel!
    @IBOutlet weak var requestItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        self.title = NSLocalizedString("request", comment: "")
        waitingResponse.text = NSLocalizedString("waitingForResponse", comment: "")
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12.0)
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView!.settings.compassButton = true
        mapView!.settings.myLocationButton = true
        mapView!.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        self.view.addSubview(mapView!)
        mapView?.layer.zPosition = -50
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        
        DispatchQueue.main.async(execute: {
            self.mapView!.isMyLocationEnabled = true
        })
        contentView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5/1)
        view.bringSubviewToFront(contentView)
        
        let realm = try! Realm()
        let user = realm.objects(Rider.self).first!
        
        
        riderId = user.rider_id
        
        print(riderId!)
        
        responseUrl = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/response/?id=\(riderId!)")!
        
        self.timer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: (#selector(getResponse)), userInfo: nil, repeats: true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !firstLocationUpdate {
            // If the first location update has not yet been received, then jump to that
            // location.
            firstLocationUpdate = true
            let location = change?[.newKey] as? CLLocation
            mapView!.camera = GMSCameraPosition.camera(withTarget: (location?.coordinate)!, zoom: 14)
        }
    }
    
    @IBAction func WaitForResponse(_ sender: Any) {
        
    }
    
    @objc func getResponse(){
        
        // creating request using url
        var responseURLRequest: URLRequest = URLRequest(url: responseUrl!)
        responseURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //creating Session using shared session
        let responseSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let responseTask = responseSession.dataTask(with: responseURLRequest, completionHandler: rideReviewRequestTask )
        
        //executing task
        responseTask.resume()
        
    }
    func rideReviewRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.requestResponseCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.requestResponseCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func requestResponseCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        } else {
            //            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8){
                
                do{
                    
                    let obj = try JSON(data: rideRequestData)
                    accepted = obj["enroute"].bool!
                    print(accepted)
                    if accepted == true {
                        let requestObj = obj["request"].dictionaryObject
                        driver_name = obj["name"].string!
                        driver_id = obj["request"]["chosen_driver_id"].string!
                        print(driver_name)
                        ride_id = obj["request"]["ride_id"].string!
                    }
                }catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                
                if(self.accepted == true){
                    self.timer?.invalidate()
                    self.self.performSegue(withIdentifier: "OnTheWaySegue", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        OnTheWaySegue
        let nextVC = segue.destination as! OnTheWayViewController
        nextVC.driverNameText = driver_name
        nextVC.riderNameText = rider_name
        nextVC.driver_id = driver_id
        nextVC.ride_id = ride_id
    }
}
