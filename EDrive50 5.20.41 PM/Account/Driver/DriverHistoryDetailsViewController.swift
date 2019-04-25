//
//  DriverDetailsFeedbackViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverHistoryDetailsViewController: UIViewController {
    
    var riderInfo: [String:Any]?
    var startAddress: [String:Any]?
    var endAddress: [String:Any]?
    var rideDate: String?
    var distanceTravelled: Int?
    
    @IBOutlet weak var feedbackDescription: UITextView!
    @IBOutlet weak var nameOfDriver: UITextView!
    @IBOutlet weak var detailImage: UIImageView!
    
    @IBOutlet weak var distanceTravelDetails: UITextView!
    @IBOutlet weak var dateDetails: UITextView!
    @IBOutlet weak var destinationDetails: UITextView!
    @IBOutlet weak var pickUpDetails: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        startAddress = self.riderInfo!["start_adress"] as? [String : Any]
        endAddress = self.riderInfo!["end_address"] as? [String : Any]
        
        pickUpDetails.text = "\(String(describing: startAddress!["street"]!)), \(String(describing: startAddress!["city"]!))\t\(String(describing: startAddress!["postal_code"]!)))"
        
        destinationDetails.text = "\(String(describing: endAddress!["street"]!)), \(String(describing: endAddress!["city"]!))\t\(String(describing: endAddress!["postal_code"]!))"
        
        dateDetails.text = "\(String(describing: rideDate!))"
    }
}
