//
//  PointAPointBViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//
import UIKit
import GooglePlaces

class PointAPointBViewController: UIViewController {
    var resultsViewController: GMSAutocompleteResultsViewController?
    var searchController: UISearchController?
    var resultView: UITextView?
    var whichTextField : String?
    @IBOutlet weak var PointAField: UITextField!
    @IBOutlet weak var PointBField: UITextField!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var bookingItem: UINavigationItem!
    @IBOutlet weak var nextBtn: UIButton!
    
    private let SW_LAT : Double = 45.0084
    private let SW_LONG : Double  = -76.3589
    private let NE_LAT : Double  = 45.5972
    private let NE_LONG : Double = -75.2433
    
    var pointA : Place?
    var pointB : Place?
    var bounds : GMSCoordinateBounds?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("booking", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        fromLabel.text = NSLocalizedString("from", comment: "")
        toLabel.text = NSLocalizedString("to", comment: "")
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        PointAField.text = pointA?.address
        PointBField.text = pointB?.address
        
    }
    
    @IBAction func PointATapped(_ sender: Any) {
        PointAField.resignFirstResponder()
        whichTextField = "Point A"
        
        let northEastCoordinate = CLLocationCoordinate2D(latitude: NE_LAT, longitude:  NE_LONG)
        let southWestCoordinate = CLLocationCoordinate2D(latitude: SW_LAT, longitude: SW_LONG)
        
        bounds = GMSCoordinateBounds(coordinate: northEastCoordinate, coordinate:southWestCoordinate)
        
        let acController = GMSAutocompleteViewController()
        acController.autocompleteBounds = bounds
        acController.autocompleteBoundsMode = .restrict
        
        acController.delegate = self
        
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func PointBTapped(_ sender: Any) {
        PointBField.resignFirstResponder()
        whichTextField = "Point B"
        
        let northEastCoordinate = CLLocationCoordinate2D(latitude: NE_LAT, longitude:  NE_LONG)
        let southWestCoordinate = CLLocationCoordinate2D(latitude: SW_LAT, longitude: SW_LONG)
        
        bounds = GMSCoordinateBounds(coordinate: northEastCoordinate, coordinate:southWestCoordinate)
        
        let acController = GMSAutocompleteViewController()
        acController.autocompleteBounds = bounds
        acController.autocompleteBoundsMode = .restrict
        acController.delegate = self
        
        present(acController, animated: true, completion: nil)
    }
    
    @IBAction func SearchButton(_ sender: Any) {
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! BookingViewController
        nextController.placeA = pointA
        nextController.placeB = pointB
    }
    
}


extension PointAPointBViewController: GMSAutocompleteViewControllerDelegate {
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
       
        
        if whichTextField == "Point A" {
            PointAField.text = place.name!
            pointA = Place.init(name: place.name!, addressComponents: place.addressComponents!, points: place.coordinate)
        } else {
            PointBField.text = place.name!
            pointB = Place.init(name: place.name!, addressComponents: place.addressComponents!, points: place.coordinate)
            
        }
        
        let point = Place.init(name: place.name!, addressComponents: place.addressComponents!, points: place.coordinate)
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // Dismiss when the user canceled the action
        dismiss(animated: true, completion: nil)
    }
    
}

