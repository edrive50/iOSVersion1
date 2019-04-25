//
//  ReceiveRequestViewController.swift
//  EDrive50
//
//  Created by Tanvideep Tanvideep on 2019-03-26.
//  Copyright © 2019 Karandeep Dalam . All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift
import SwiftyJSON

class ReceiveRequestViewController: UIViewController {
    
    @IBOutlet weak var AcceptRide: UIImageView!
    @IBOutlet weak var ReceiveRequest: UIImageView!
    @IBOutlet weak var rideRequestInfo: UITextView!
    @IBOutlet weak var requestCard: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var rideStatusUpdate: UITextView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var driveItem: UINavigationItem!
    
    let APIKEY = "AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU"
    var jsonObject : [String:Any]?
    var startAddress : [String:Any]?
    var endAddress : [String:Any]?
    var request : [String: Any]?
    var status : String?
    var riderId = ""
    var answer:Bool?
    var response = false
    var rectangle = GMSPolyline()
    var rectangle2 = GMSPolyline()
    var user : Driver?
    var timer : Timer?
    var driver_id : String?
    var rideRequestUrl: URL?
    var rider_name: String?
    var lineNum = 1
    
    var street_num : String?
    var street : String?
    var city : String?
    
    
    private var driversSourceLat : Double?
    private var driversSourceLong : Double?
    private var ridersSourceLat : Double?
    private var ridersSourceLong : Double?
    private var ridersDestinationLat : Double?
    private var ridersDestinationLong : Double?
    private var firstLocationUpdate = false
    private var mapView: GMSMapView?
    private var destLat : String?
    private var destLong : String?
    private var polylineColour: UIColor?
    private var driversCurrentLocation: CLLocationCoordinate2D?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("drive", comment: "")
        rejectBtn.setTitle(NSLocalizedString("reject", comment: ""), for: .normal)
        acceptBtn.setTitle(NSLocalizedString("accept", comment: ""), for: .normal)
        statusView.isHidden = true
        requestCard.isHidden = true

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
        let pinColor = UIColor.green
        marker.icon = GMSMarker.markerImage(with: pinColor)
        marker.map = mapView
        
        DispatchQueue.main.async(execute: {
            self.mapView!.isMyLocationEnabled = true
        })
        
        view.bringSubviewToFront(requestCard)
        
        let realm = try! Realm()
        user = realm.objects(Driver.self).first!
        
        print("users")
        print(user!)
        
        driver_id = user?.driver_id
        print(driver_id!)
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector (reviewRequest (_:)))
        requestCard.addGestureRecognizer(gesture)
        print("ID")
        print(driver_id!)
        rideRequestUrl = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/?id=\(driver_id!)")!
        
        self.timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: (#selector(getRequest)), userInfo: nil, repeats: true)
    }
    
    @objc func getRequest() {

        // creating request using url
        var rideRequestURLRequest: URLRequest = URLRequest(url: rideRequestUrl!)
        rideRequestURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //creating Session using shared session
        let rideRequestSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let rideRequestTask = rideRequestSession.dataTask(with: rideRequestURLRequest, completionHandler: requestTask)
        
        //executing task
        rideRequestTask.resume()
    }
    
    // creating completion handler request task function to process server data and any errors if they exist
    func requestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.rideRequestCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.rideRequestCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func rideRequestCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        } else {
            print(responseString)
            //converting json string to data
            
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8){
                
                do{
                    
                    let obj = try JSON(data: rideRequestData)
                    response = obj["is_found"].bool!
                    if response == true {
                        startAddress = obj["request"][0]["rider_info"]["start_address"].dictionaryObject
                        endAddress = obj["request"][0]["rider_info"]["end_address"].dictionaryObject
                        rider_name = obj["request"][0]["rider_info"]["rider_name"].string

                        if startAddress!["street_num"] != nil {
                            street_num = (startAddress!["street_num"] as! String)
                            print(startAddress!["street_num"]!)
                        } else {
                            street_num = ""
                        }
                        
                        if startAddress!["street"] != nil {
                            street = startAddress!["street"] as? String
                            print(startAddress!["street"]!)
                        } else {
                            street = ""
                        }
                        
                        if startAddress!["city"] != nil {
                            city = (startAddress!["city"] as! String)
                            print(startAddress!["city"]!)
                        } else {
                            city = ""
                        }
                        
                    }
                
                } catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            if response == true {
                // Update the UI on the main thread with the new data
                DispatchQueue.main.async {
                    self.rideRequestInfo.text = "\(self.rider_name!) \n\n Special Needs\n Wheelchair Asseccible \n\n \(self.street_num!) \(self.street!), \(self.city!)"
                    self.requestCard.isHidden = false
                    
                }
            }
            
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched")
    }
    
    @IBAction func acceptRequestBtnTapped(_ sender: Any) {
        timer?.invalidate()
        requestCard.isHidden = true
        AcceptRide.image = UIImage(named: "acceptRequests.png")
        AcceptRide.tintColor = UIColor.red // to change teh color of the card if required
        answer = true //result of the response
        sendResponse()
        delay()
    }
    
    @IBAction func rejectRequestBtnTapped(_ sender: Any) {
        timer?.invalidate()
        requestCard.isHidden = true
        AcceptRide.image = UIImage(named: "rejectRequest.png")
        AcceptRide.tintColor = UIColor.red // to change teh color of the card if required
        answer = false //result of the response
        sendResponse()
        delay()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !firstLocationUpdate {
            // If the first location update has not yet been received, then jump to that
            // location.
            firstLocationUpdate = true
            let location = change?[.newKey] as? CLLocation
            driversCurrentLocation = location?.coordinate
            driversSourceLat = (driversCurrentLocation?.latitude)!
            driversSourceLong = (driversCurrentLocation?.longitude)!
            mapView!.camera = GMSCameraPosition.camera(withTarget: (location?.coordinate)!, zoom: 14)
        }
    }
    
    func getRoute() {
        let sourceLatitude = String(self.ridersSourceLat!)
        let sourceLongitude = String(self.ridersSourceLong!)
        
        let destinationLatitude = String(self.ridersDestinationLat!)
        let destinationLongitude = String(self.ridersDestinationLong!)
        
        let driversLatitude = String(self.driversSourceLat!)
        let driversLongitude = String(self.driversSourceLong!)
        
        print("Driver To Start:(\(driversLatitude), \(driversLongitude) Destination: (\(sourceLatitude), \(sourceLongitude) ")
        print("Route Source: (\(sourceLatitude), \(sourceLongitude)), Destination: (\(destinationLatitude), \(destinationLongitude))")
        
        // draw drivers destination to point a
        polylineColour = UIColor.red
        drawPolyline(sLat: driversLatitude, sLong: driversLongitude, dLat: sourceLatitude, dLong: sourceLongitude)

        // draw point a to point b
        polylineColour = UIColor.blue
        drawPolyline(sLat: sourceLatitude, sLong: sourceLongitude, dLat: destinationLatitude, dLong: destinationLongitude)
    }
    
    func drawPolyline(sLat: String, sLong: String, dLat: String, dLong: String) {
        
        // Draw Route between Source to Search place location
        
        let a_coordinate_string = "\(sLat),\(sLong)"
        let b_coordinate_string = "\(dLat),\(dLong)"
        print("Source: (\(a_coordinate_string)), Destination: (\(b_coordinate_string))")
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&sensor=false&key=AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU"
        
        
        print(urlString)
        let url = URL(string: urlString)!
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: requestPolylineTask)
        
        task.resume()
    }
    
    @objc func reviewRequest(_ sender: UIPanGestureRecognizer){
        let card = sender.view!
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x // to calculate the distance of card being dragged on either side
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        if xFromCenter > 100 { // card is being dragged on right
            timer?.invalidate()
            AcceptRide.image = UIImage(named: "acceptRequests.png")
            AcceptRide.tintColor = UIColor.red // to change teh color of the card if required
            answer = true //result of the response
            sendResponse()
            
            delay()
            
        }
        else if xFromCenter < -100 {
            timer?.invalidate()
            AcceptRide.image = UIImage(named: "rejectRequest.png")
            AcceptRide.tintColor = UIColor.red // to change teh color of the card if required
            answer = false //result of the response
            sendResponse()
            delay()
        }
        
        // to make the picture more opaque when you move it to the edges
        AcceptRide.alpha = abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended  // when the finger comes off the screen
        {
            if card.center.x < 75
            {
                // Move off to the left side of the screen
                UIView.animate(withDuration: 0.3) {// animating the card off the screen
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    card.alpha = 0
                    
                }
                return
            }
            else if card.center.x > (view.frame.width - 75)
            {
                // Move off to the right side of the screen
                UIView.animate(withDuration: 0.3) {// animating teh card off the screen
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    card.alpha = 0
                }
                return
            }
            
            reset()
        }
        
    }
    
    
    
    func delay(){
        // Delay the dismissal by 3 seconds
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            
            self.AcceptRide.isHidden = true
            if(self.answer == true){
                self.statusView.backgroundColor = UIColor(red: 29/255, green: 99/255, blue: 58/255, alpha: 0.7)
                self.rideStatusUpdate.backgroundColor = UIColor(red: 29/255, green: 99/255, blue: 58/255, alpha: 0.1)
                self.rideStatusUpdate.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
                self.statusView.isHidden = false
            }
        }
    }
    
    func reset() {
        UIView.animate(withDuration: 0.2, animations: {
            self.requestCard.center = self.view.center
            self.AcceptRide.alpha = 0
            self.requestCard.alpha = 1
        })
    }
    

    
    func requestPolylineTask(_ serverData: Data?, serverResponse: URLResponse?, serverError:Error?) -> Void {
        print("here")
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            
            self.callBack(responseString: "", error: serverError?.localizedDescription)
        }
        else {
            // Stringfy the response data
            let result = String(data: serverData!, encoding: String.Encoding.utf8)!
            // Send the response string data, and nil for the error tot he callback
            self.callBack(responseString: result as String, error:nil)
        }
    }
    
//    https://stackoverflow.com/questions/28124119/convert-html-to-plain-text-in-swift
    func decodeString(encodedString:String) -> NSAttributedString? {
        let encodedData = encodedString.data(using: .utf8)
        do {
            return try NSAttributedString(data: encodedData!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    // Define the callback function to be triggered when the response is recieved
    func callBack(responseString: String, error: String?) {
        // If the server request generated an error then handle it
        if error != nil {
            print("ERROR is " + error!)
        } else {
            // Else take the data recieved from the server and process it
            // Take the response string and turn it back into raw data
            // Convert server json response to NSDictionary
//            print(responseString)
            
            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: myData, options: []) as! NSDictionary
                    let json2 = try JSON(data: myData)
                    print(json)
                    
                    // Extract Distance and Time
                    let arrayRoutes = json["routes"] as! NSArray
                    let arrLegs = (arrayRoutes[0] as! NSDictionary).object(forKey: "legs") as! NSArray
                    let arrSteps = arrLegs[0] as! NSDictionary
                    
                    let dicDistance = arrSteps["distance"] as! NSDictionary
                    let distance = dicDistance["text"] as! String
                    
                    let dicDuration = arrSteps["duration"] as! NSDictionary
                    let duration = dicDuration["text"] as! String
                    
                    print("\(distance), \(duration)")
                    DispatchQueue.global(qos: .background).async {
                        // Extract overview_polyline key
                        let array = json["routes"] as! NSArray
                        let dic = array[0] as! NSDictionary
                        let dic1 = dic["overview_polyline"] as! NSDictionary
                        let points = dic1["points"] as! String
                        let instructions = json2["routes"][0]["legs"][0]["steps"][0]["html_instructions"].string
                        _ = Data(instructions!.utf8)
                        let attributedString = self.decodeString(encodedString: instructions!)
                        let instructionString = attributedString!.string
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.rideStatusUpdate.text = "\(distance) \(duration) \n\n\(instructionString)"
                            //            self.mapView!.isMyLocationEnabled = true
                            let path = GMSPath(fromEncodedPath: points)
                            if self.lineNum == 1 {
                                
                                self.rectangle.map = nil
                                self.rectangle = GMSPolyline(path: path)
                                self.rectangle.strokeWidth = 4
                                self.rectangle.strokeColor = UIColor.red
                                self.rectangle.map = self.mapView
                                self.view.addSubview(self.rectangle.map!)
                                self.lineNum += 1
                                
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: self.ridersSourceLat!, longitude: self.ridersSourceLong!)
                                marker.title = "Rider"
                                let pinColor = UIColor.blue
                                marker.icon = GMSMarker.markerImage(with: pinColor)
                                marker.map = self.mapView
                                
                            } else if self.lineNum == 2 {
                                
                                self.rectangle2.map = nil
                                self.rectangle2 = GMSPolyline(path: path)
                                self.rectangle2.strokeWidth = 4
                                self.rectangle2.strokeColor = UIColor.blue
                                self.rectangle2.map = self.mapView
                                self.view.addSubview(self.rectangle2.map!)
                                
                                let marker = GMSMarker()
                                marker.position = CLLocationCoordinate2D(latitude: self.ridersDestinationLat!, longitude: self.ridersDestinationLong!)
                                marker.title = "Destination"
                                let pinColor = UIColor.red
                                marker.icon = GMSMarker.markerImage(with: pinColor)
                                marker.map = self.mapView
                            }
                            
                        })
                    }
                    
                    
                } catch let convertError {
                    // If it fails catch the error info
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    
    
    func sendResponse() {
        // creating url for data request

        let responseUrl: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/answer/?answer=\(answer!)&id=\(driver_id!)")!
        
        // creating request using url
        var responseURLRequest: URLRequest = URLRequest(url: responseUrl)
        //            responseURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        responseURLRequest.httpMethod = "PUT"
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
        } else {
        
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
            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8) {
                
                do {
                    
                    let obj = try JSON(data: rideRequestData)
                    response = obj["accept"].bool!
                    if response == true {
                        
                        ridersSourceLat = (startAddress!["latitude"] as! Double)
                        ridersSourceLong = (startAddress!["longitude"] as! Double)
                        ridersDestinationLat = (endAddress!["latitude"] as! Double)
                        ridersDestinationLong = (endAddress!["longitude"] as! Double)
                        
                        getRoute()
                    } else {
                        
                    }
                    
                } catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                if(self.answer == true){
                    self.rideStatusUpdate!.text = ""
                }
                
            }
            
        }
    }
}

