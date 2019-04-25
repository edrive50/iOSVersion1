//
//  DrivingMapViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-30.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class DrivingMapViewController: UIViewController {
    
    let APIKEY = "AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU"
    
    private let sourceLat : Double  = 45.5972
    private let sourceLong : Double = -75.2433
    
    private let destLat : Double = 45.0084
    private let destLong : Double  = -76.3589
    
    var rectangle = GMSPolyline()
    var marker = GMSMarker()
    
    var geoCoodinates: [String :AnyObject]?
    private var firstLocationUpdate = false
    private var mapView: GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let c = GMSCameraPosition.camera(withLatitude: 37.36, longitude: -122.0, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: c)
        
        mapView!.settings.compassButton = true
        mapView!.settings.myLocationButton = true
        mapView!.addObserver(self, forKeyPath: "myLocation", options: .new, context: nil)
        
        self.view.addSubview(mapView!)
        //rectangle.map
        
        let camera = GMSCameraPosition.camera(withLatitude: sourceLat, longitude: sourceLong, zoom: 12.0)
        mapView?.camera = camera
        
        let position = CLLocationCoordinate2DMake(sourceLat, sourceLong)
        self.marker = GMSMarker(position: position)
        
        let pinColor = UIColor.green
        self.marker.icon = GMSMarker.markerImage(with: pinColor)
        
        self.marker.map = self.mapView
        
        
        // Draw Route between Source to Search place location
        let sLat = String(self.sourceLat)
        let sLong = String(self.sourceLong)
        
        let dLat = String(self.destLat)
        let dLong = String(self.destLong)
        
        let a_coordinate_string = "\(sLat),\(sLong)"
        let b_coordinate_string = "\(dLat),\(dLong)"
        
        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&sensor=false&key=AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU"
        
        
        print(urlString)
        let url = URL(string: urlString)!
        
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: requestTask)
        
        task.resume()
        
    }
    
    
    func requestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError:Error?) -> Void {
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
    
    // Define the callback function to be triggered when the response is recieved
    func callBack(responseString: String, error: String?) {
        // If the server request generated an error then handle it
        if error != nil {
            print("ERROR is " + error!)
        } else {
            // Else take the data recieved from the server and process it
            // Take the response string and turn it back into raw data
            // Convert server json response to NSDictionary
            print(responseString)
            
            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                    let json = try JSONSerialization.jsonObject(with: myData, options: []) as! NSDictionary
                    
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
                        print(points)
                        DispatchQueue.main.async(execute: {
                            //            self.mapView!.isMyLocationEnabled = true
                            let path = GMSPath(fromEncodedPath: points)
                            self.rectangle.map = nil
                            self.rectangle = GMSPolyline(path: path)
                            self.rectangle.strokeWidth = 4
                            self.rectangle.strokeColor = UIColor.blue
                            self.rectangle.map = self.mapView
                            self.view.addSubview(self.rectangle.map!)
                        })
                    }
                    
                    
                } catch let convertError {
                    // If it fails catch the error info
                    print(convertError.localizedDescription)
                }
            }
        }
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
    
}


