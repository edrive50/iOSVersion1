//
//  DriverListViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-28.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

struct cellData {
    var open = Bool()
    var title = String()
    var sectionData = [String]()
}

class DriverListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var driversTableView: UITableView!
    @IBOutlet weak var requestItem: UINavigationItem!
    
    var driverListObject : [String:[[String:Any]]]?
    var driver_id: String?
    var rider_id: String?
    var user : Rider?
    var placeA : Place?
    var placeB : Place?
    
    var riderObj : [String : Any] = [:]
    var riderInfo : [String : Any] = [:]
    var start_address : [String : Any] = [:]
    var end_address : [String : Any] = [:]
    var accessibility_options : [String : Any] = [:]
    var starArray = [UIImageView]()
    var isScheduled = false
    var scheduledRide:RideInfo?
    var fromSchedule = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("request", comment: "")
        
        
        let realmInfo = try! Realm()
        if(isScheduled == true){
            scheduledRide = realmInfo.objects(RideInfo.self).first!
        }
        
        
        var pointA : CLLocationCoordinate2D?
        var pointB : CLLocationCoordinate2D?
        
        if(isScheduled == true){
            //location of the two points
            pointA = CLLocationCoordinate2D(latitude: scheduledRide!.pickUplatitude, longitude:  scheduledRide!.pickUpLogitude)
            pointB = CLLocationCoordinate2D(latitude: scheduledRide!.destinationlatitude, longitude:  scheduledRide!.destinationLogitude)
        }else{
            // Location of the two points
            pointA = placeA?.points
            pointB = placeB?.points
        }
        
        
        // Set the the points as markers
        let pointAMarker = MKPlacemark(coordinate: pointA!, addressDictionary: nil)
        let pointBMarker = MKPlacemark(coordinate: pointB!, addressDictionary: nil)
        
        // Create the map items
        let pointAMapItem = MKMapItem(placemark: pointAMarker)
        let pointBMapItem = MKMapItem(placemark: pointBMarker)
        
        // Annotations
        let pointAAnnotation = MKPointAnnotation()
        pointAAnnotation.title = "Point A"
        
        if let location = pointAMarker.location {
            pointAAnnotation.coordinate = location.coordinate
        }
        
        
        let pointBAnnotation = MKPointAnnotation()
        pointBAnnotation.title = "Point B"
        
        if let location = pointBMarker.location {
            pointBAnnotation.coordinate = location.coordinate
        }
        
        // put annotations on the map
        self.mapView.showAnnotations([pointAAnnotation, pointBAnnotation], animated: true)
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = pointAMapItem
        directionRequest.destination = pointBMapItem
        directionRequest.transportType = .automobile
        
        //calculate directions on map
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate { (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
            self.mapView.delegate = self
        }
        
        let driverFinderURL: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/available-rides/")!
        var driverFinderURLRequest: URLRequest =  URLRequest(url: driverFinderURL);
        driverFinderURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //creating Session using shared session
        let driverSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let driverTask = driverSession.dataTask(with: driverFinderURLRequest, completionHandler: finderRequestTask )
        
        //executing task
        driverTask.resume()
        
        // Do any additional setup after loading the view.
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //using optional binding to return json array count
        if let data = driverListObject {
            return data["drivers"]!.count //returns data.count if it exist
            
        } else {
            //this block of code runs if jsondata doesnot exist
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //getting a copy of the dequeued reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "driverListCell", for: indexPath) as! DriverListTableViewCell
        
        //using optional binding to access jsonData object if it exist
        if let driverListArray = driverListObject {
            
            //getting the current dictionary with indexPath.row
            var driverListItem = driverListArray["drivers"]!
            var dataItem = driverListItem[indexPath.row]
            
            //setting each tableViewCell's textLabel with the 'eventTitle' and 'eventDate' from the current dictionary
            starArray = [cell.star1, cell.star2, cell.star3, cell.star4, cell.star5]
            cell.DriverNameText.text = "Name: \(dataItem["name"]!)"
            
            let numRating = dataItem["rating"]! as? Int
            let num = numRating! - 1
            if(num >= 0){
                for index in 0...num {
                    starArray[index].image = UIImage(named: "FilledStar.png")
                }

            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let driverListArray = driverListObject {
            var driverListItem = driverListArray["drivers"]!
            var dataItem = driverListItem[indexPath.row]
            //            print(dataItem)
            //setting each tableViewCell's textLabel with the 'eventTitle' and 'eventDate' from the current dictionary
            driver_id = dataItem["driver_id"]! as? String
        }
        
        let realm = try! Realm()
        user = realm.objects(Rider.self).first!
        
        self.rider_id = user?.rider_id
        let name = user?.name
        
        let rider_id = self.rider_id
        _ = driver_id
        
        if(isScheduled == true){
            print("scheduled")
            //        var start_address
            start_address["street_num"] = scheduledRide?.pickUpStreetNum
            start_address["street"] = scheduledRide?.pickUpStreetName
            start_address["city"] = scheduledRide?.pickUpCity
            start_address["prov"] = scheduledRide?.pickUpProvince
            start_address["postal_code"] = scheduledRide?.pickUpPostal
            start_address["latitude"] = scheduledRide?.pickUplatitude
            start_address["longitude"] = scheduledRide?.pickUpLogitude
            
            //        var end_address
            start_address["street_num"] =  scheduledRide?.destinationStreetNum
            end_address["street"] = scheduledRide?.destinationStreetName
            end_address["city"] = scheduledRide?.destinationCity
            end_address["prov"] = scheduledRide?.destinationProvince
            end_address["postal_code"] = scheduledRide?.destinationPostal
            end_address["latitude"] =  scheduledRide?.destinationlatitude
            end_address["longitude"] =  scheduledRide?.destinationLogitude
            
            isScheduled = false
            scheduledRide?.delete(rideInfo: scheduledRide!)
        }else{
            
            //        var start_address
            start_address["street_num"] = placeA?.street_number
            start_address["street"] = placeA?.street_name
            start_address["city"] = placeA?.city
            start_address["prov"] = placeA?.prov
            start_address["postal_code"] = placeA?.postal_code
            start_address["latitude"] = placeA?.points.latitude
            start_address["longitude"] = placeA?.points.longitude
            
            //        var end_address
            start_address["street_num"] =  placeB?.street_number
            end_address["street"] = placeB?.street_name
            end_address["city"] = placeB?.city
            end_address["prov"] = placeB?.prov
            end_address["postal_code"] = placeB?.postal_code
            end_address["latitude"] =  placeB?.points.latitude
            end_address["longitude"] =  placeB?.points.longitude

        }
        
        //        var accessibility_options
        accessibility_options["wheelchair"] = user?.wheelchair
        accessibility_options["walker"] = user?.physical_assistance
        accessibility_options["big_trunk"] = user?.big_truck
        accessibility_options["other_details"] = user?.other_details
        
        //        var rider_info
        riderInfo["start_address"] = start_address
        riderInfo["end_address"] = end_address
        riderInfo["accessibility_options"] = accessibility_options
        riderInfo["rider_name"] = name!
        riderInfo["rider_image"] = "[[Image]]"
        
        riderObj["rider_id"] = rider_id
        /******************** we need to get the data when the list is clicked *******************************/
        
        riderObj["chosen_driver_id"] = driver_id!
        riderObj["ride_time"] = -1
        /******************** ********************************************** *******************************/
        riderObj["rider_info"] = riderInfo
        
        print(riderInfo)
        do {
            let driverRequestURL: URL = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/ride-request/")!
            var driverRequestURLRequest: URLRequest =  URLRequest(url: driverRequestURL);
            driverRequestURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            driverRequestURLRequest.httpMethod = "POST"
            
            let riderData = try JSONSerialization.data(withJSONObject: riderObj, options: [])
            driverRequestURLRequest.httpBody = riderData
            
            let driverRequestSession: URLSession = URLSession.shared
            // creating task object from the session by passing in request and the completion handler
            let driverTask = driverRequestSession.dataTask(with: driverRequestURLRequest, completionHandler: driverRequestTask )
            
            //executing task
            driverTask.resume()
        } catch {
            //outputting error if error occurs
            print ("Coverted error = \(error.localizedDescription)")
        }
        //creating Session using shared session
        
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
            
            //converting json string to data
            if let driverData:Data = responseString.data(using: String.Encoding.utf8){
        
                do {
                    //converting data to json object and storing it in jsonObject
                    driverListObject = try (JSONSerialization.jsonObject(with: driverData, options: []) as? [String:[[String:Any]]])
                } catch let convertError {
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                self.driversTableView?.reloadData() //reloading tableView on main thread
            }
        }
    }
    
    func finderRequestTask (_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            self.finderCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        } else {
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            self.finderCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
        }
    }
    
    func finderCallBack(responseString:String, error:String?) {
        
        if error != nil {
            //outputting error if error occurs
            print(error!)
        } else {
            //            print(responseString)
            
            //converting json string to data
            if let driverData:Data = responseString.data(using: String.Encoding.utf8){
                //                print(driverData)
                do {
                    //converting data to json object and storing it in jsonObject
                    driverListObject = try (JSONSerialization.jsonObject(with: driverData, options: []) as? [String:[[String:Any]]])
                } catch let convertError {
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
            // Update the UI on the main thread with the new data
            DispatchQueue.main.async {
                self.driversTableView?.reloadData() //reloading tableView on main thread
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 106
    }
    
}
