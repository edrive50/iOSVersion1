//
//  DriverDetailsFeedabackViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-02.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverDetailsFeedabackViewController: UIViewController {
    var riderInfo: [String:Any]?
    var startAddress: [String:Any]?
    var endAddress: [String:Any]?
    var rideDate: String?
    
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var dateLabell: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var pickUpLabe: UILabel!
    @IBOutlet weak var feedbackDescription: UITextView!
    @IBOutlet weak var riderImage: UIImageView!
    @IBOutlet weak var travelledDistance: UITextView!
    @IBOutlet weak var driverPickup: UITextView!
    @IBOutlet weak var dateOfRide: UITextView!
    @IBOutlet weak var driverDestination: UITextView!
    
    @IBAction func touchAction(_ sender: UIButton) {
        
        print("Rated \(sender.tag) stars.")
        
        for button in starFeedback {
            
            if button.tag <= sender.tag {
                button.setBackgroundImage(UIImage.init(named: "StarFilled"), for: .normal)
            }
            else{
                button.setBackgroundImage(UIImage.init(named: "StarEmpty"), for: .normal)
            }
        }
    }
    @IBOutlet var starFeedback: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("details", comment: "")
        pickUpLabe.text = NSLocalizedString("pickUp", comment: "")
        destinationLabel.text = NSLocalizedString("destination", comment: "")
        distanceLabel.text = NSLocalizedString("distanceTravelled", comment: "")
        dateLabell.text = NSLocalizedString("date", comment: "")
        riderLabel.text = NSLocalizedString("rider", comment: "")
        feedbackLabel.text = NSLocalizedString("yourFeedback", comment: "")
        
        startAddress = self.riderInfo!["start_adress"] as? [String : Any]
        endAddress = self.riderInfo!["end_address"] as? [String : Any]
        
        driverPickup.text = "\(String(describing: startAddress!["street"]!)), \(String(describing: startAddress!["city"]!))\t\(String(describing: startAddress!["postal_code"]!))"
        
        driverDestination.text = "\(String(describing: endAddress!["street"]!)), \(String(describing: endAddress!["city"]!))\t\(String(describing: endAddress!["postal_code"]!))"
        
        dateOfRide.text = "\(String(describing: rideDate!))"    }

}
