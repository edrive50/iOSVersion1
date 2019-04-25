//
//  MapAndSearchViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//
import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import RealmSwift


class MapAndSearchViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusUpdate: UITextView!
    @IBOutlet weak var feedBackBtn: UIButton!
    @IBOutlet var SearchView: UIView!
    @IBOutlet weak var searchItem: UINavigationItem!
    @IBOutlet weak var familyContact: UIButton!
    
    @IBOutlet weak var findDriver: UIButton!
    let APIKEY = "AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU"
    private let SW_LAT : Double = 45.0084
    private let SW_LONG : Double  = -76.3589
    private let NE_LAT : Double  = 45.5972
    private let NE_LONG : Double = -75.2433
    private var firstLocationUpdate = false
    private var mapView: GMSMapView?
    
    var driver_id : String?
    var driver_name : String?
    var isBooked = false
    var geoCoodinates: [String :AnyObject]?
    var bounds : GMSCoordinateBounds?
    var searchTerm : Place?
    var currentAddress : Place?
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var currentLocation : CLLocationCoordinate2D?
    let marker = GMSMarker()
    var currentPlaceID : String?
    var locationManager = CLLocationManager()
    var currentL: CLLocation?
    var placesClient: GMSPlacesClient!
    var ride_id:String?
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("search", comment: "")
        feedBackBtn.setTitle(NSLocalizedString("giveFeedback", comment: ""), for: .normal)
//        contentView.isHidden = true
        familyContact.isHidden = true
        statusView.isHidden = true
        statusUpdate.isHidden = true
        feedBackBtn.isHidden = true
        findDriver.isHidden = true
        
        
        let realmInstance = try! Realm()
        let rideInformation = realmInstance.objects(RideInfo.self).first
        
        print(rideInformation)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

        let northEastCoordinate = CLLocationCoordinate2D(latitude: NE_LAT, longitude:  NE_LONG)
        let southWestCoordinate = CLLocationCoordinate2D(latitude: SW_LAT, longitude: SW_LONG)
        
        bounds = GMSCoordinateBounds(coordinate: northEastCoordinate, coordinate:southWestCoordinate)
        
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 12.0)
        
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView!.settings.compassButton = true
        mapView!.settings.myLocationButton = true
//        mapView!.settings.scrollGestures = false
//        mapView!.settings.zoomGestures = false
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
        
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        resultsViewController?.autocompleteBounds = bounds
        resultsViewController?.autocompleteBoundsMode = .restrict
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.delegate = self
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = NSLocalizedString("searchDestination", comment: "")

        self.view.bringSubviewToFront(contentView)
        print("loaded")
        if !isBooked {
            navigationItem.titleView = searchController?.searchBar

        } else {
            self.statusView.backgroundColor = UIColor(red: 29/255, green: 99/255, blue: 58/255, alpha: 0.7)
            self.statusUpdate.text = "\(self.driver_name!) " + NSLocalizedString("isOnTheWay", comment: "")
            self.statusView.isHidden = false
            self.statusUpdate.isHidden = false
            self.familyContact.isHidden = false
//            self.contentView.isHidden = false
            // end ride
            let when = DispatchTime.now() + 10
            DispatchQueue.main.asyncAfter(deadline: when) {

                self.statusUpdate.text = "\(self.driver_name!) " + NSLocalizedString("hasArrived", comment: "")
                
                let now = DispatchTime.now() + 7
                DispatchQueue.main.asyncAfter(deadline: now) {
                    
                    self.feedBackBtn.isHidden = false
                    self.statusUpdate.text = NSLocalizedString("tellUs", comment: "") + "\(self.driver_name!)" + NSLocalizedString("today", comment: "")

                }

            }

            
        }
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false
        
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
    }
    
    @IBAction func findDriverBtnTapped(_ sender: Any) {
        findDriver.isHidden = true
    }
    
    @objc func didBecomeActive() {
        print("did become active")
        let realmInstance = try! Realm()
        let rideInformation = realmInstance.objects(RideInfo.self).first
        let notifiedVal = rideInformation?.isNotified
        
        if(notifiedVal == 2){
            findDriver.isHidden = false
        }
        print(notifiedVal)
    }

    @IBAction func familyContactBtnTapped(_ sender: Any) {
        let realm = try! Realm()
        let rider = realm.objects(Rider.self).first
        let EmergencyContact = rider?.emergency_number
        
        guard let number = URL(string: "tel://" + EmergencyContact!) else { return }
        UIApplication.shared.open(number)
        
    }
    
    @IBAction func feedbackBtnTapped(_ sender: Any) {
        self.statusUpdate.text = "Thank you for your feedback on your ride with \(self.driver_name)"
        self.performSegue(withIdentifier: "FeedbackSegue", sender: nil)
        self.feedBackBtn.isHidden = true
    }
    
    // Populate the array with the list of likely places.
    func listLikelyPlaces() {
        // Clean up from previoletsessions.
        likelyPlaces.removeAll()
        
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                return
            }
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                let place = likelihoodList.likelihoods[0].place
                self.currentPlaceID = place.placeID
                self.getCurrentLocation(place.placeID!)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if !firstLocationUpdate {
            // If the first location update has not yet beeleteceived, then jump to that
            // location.
            firstLocationUpdate = true
            let location = change?[.newKey] as? CLLocation
            currentLocation = location?.coordinate
            marker.position = currentLocation!
            marker.title = "Current Location"
            marker.map = mapView
            currentAddress = Place.init(address: "Current Location", points: location!.coordinate)
            mapView!.camera = GMSCameraPosition.camera(withTarget: (location?.coordinate)!, zoom: 14)
            listLikelyPlaces()
        }
        
    }
    
    @IBAction func testing(_ sender: Any) {
        print("worked")
    }
    func getCurrentLocation(_ currentPlace: String) {
//        print(currentPlace)
        let responseUrl = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?placeid=\(currentPlace)&key=AIzaSyBLjT9Mbof73G0CyMYoeBQpijZ4kynLjhU")!
        // creating request using url
        var responseURLRequest: URLRequest = URLRequest(url: responseUrl)
        responseURLRequest.addValue("x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        //creating Session using shared session
        let responseSession: URLSession = URLSession.shared
        
        // creating task object from the session by passing in request and the completion handler
        let responseTask = responseSession.dataTask(with: responseURLRequest, completionHandler: currentPlaceRequestTask )
        
        //executing task
        responseTask.resume()
    }
    
    func currentPlaceRequestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError: Error?) -> Void{
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            
            self.currentPlaceResponseCallBack(responseString: "", error: serverError?.localizedDescription) // Sending error message if error occured
        }else{
            
            //converting response data to strings
            let response = String(data: serverData!, encoding: String.Encoding.utf8)!
            
            self.currentPlaceResponseCallBack(responseString: response as String, error: nil) //sending response string if there are no errors
            
        }
    }
    
    func currentPlaceResponseCallBack(responseString:String, error:String?) {
        
        if error != nil {
            
            //outputting error if error occurs
            print(error!)
            
        } else {
            //            print(responseString)
            //converting json string to data
            if let rideRequestData:Data = responseString.data(using: String.Encoding.utf8){
                
                do{
                    
                    let obj = try JSON(data: rideRequestData)
//                    print(obj)
                    var addresscomponents = obj["result"]["address_components"]
                    currentAddress?.street_number = addresscomponents[0]["short_name"].string!
                    currentAddress?.street_name = addresscomponents[1]["short_name"].string!
                    currentAddress?.city = addresscomponents[3]["short_name"].string!
                    currentAddress?.prov = addresscomponents[5]["short_name"].string!
                    currentAddress?.postal_code = addresscomponents[7]["short_name"].string!
//                    print(addresscomponents[0]["short_name"].string)
                    currentAddress?.manual = true
//                    print(currentAddress?.toAddressString())
                    
                }catch let convertError {
                    
                    // the catch block runs if there is an error i.e. catching error whenit occurs
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    // FIX
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //        performSegue(withIdentifier: "PointAPointBSegue", sender: self)
        performSegue(withIdentifier: "PointAPointBSegue", sender: self)
        searchBar.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PointAPointBSegue" {
            let nextController = segue.destination as! PointAPointBViewController
            nextController.pointA = currentAddress
            nextController.pointB = searchTerm
        } else if(segue.identifier == "showDriverList"){
            let nextController = segue.destination as! DriverListViewController
            nextController.isScheduled = true

        }else{
            let nextController = segue.destination as! FeedbackViewController
            nextController.driver_id = driver_id
            nextController.ride_id = ride_id
            nextController.driver_name = driver_name
        }
        
    }

    
}

// Delegates to handle events for the location manager.
extension MapAndSearchViewController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        
        
    }
// Handle authorization for the location manager.
func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

    }
}

extension MapAndSearchViewController:UISearchControllerDelegate {
    
    func didDismissSearchController(_ searchController: UISearchController) {
        performSegue(withIdentifier: "PointAPointBSegue", sender: self)
    }
}


// Handle the user's selection.
extension MapAndSearchViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        searchTerm = Place.init(name: place.name!, addressComponents: place.addressComponents!, points: place.coordinate)
        // Do something with the selected place.
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
