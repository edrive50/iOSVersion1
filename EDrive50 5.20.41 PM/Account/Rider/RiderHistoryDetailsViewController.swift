//
//  RiderHistoryDetailsViewController.swift
//  edrive50
//
//  Created by Karandeep Dalam  on 2019-04-02.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderHistoryDetailsViewController: UIViewController {

    var riderInfo: [String:Any]?
    var startAddress: [String:Any]?
    var endAddress: [String:Any]?
    var rideDate: String?
    var driverRating:Double?
    var starArray = [UIImageView]()

    @IBOutlet weak var pickUpAddress: UILabel!
    @IBOutlet weak var Destination: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var driverPic: UIImageView!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var ratingStar1: UIImageView!
    @IBOutlet weak var ratingStar2: UIImageView!
    @IBOutlet weak var ratingStar3: UIImageView!
    @IBOutlet weak var ratingStar4: UIImageView!
    @IBOutlet weak var ratingStar5: UIImageView!
    
    @IBOutlet weak var pickUpLabel: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var drivenBy: UILabel!
    @IBOutlet weak var ratedby: UILabel!
    @IBOutlet weak var yourFeedback: UILabel!
    @IBOutlet weak var detailsItem: UINavigationItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("details", comment: "")
        yourFeedback.text = NSLocalizedString("yourFeedback", comment: "")
        ratedby.text = NSLocalizedString("rated", comment: "")
        drivenBy.text = NSLocalizedString("driver", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        destinationLabel.text = NSLocalizedString("destination", comment: "")
        pickUpLabel.text = NSLocalizedString("pickUp", comment: "")
        
       startAddress = self.riderInfo!["start_adress"] as? [String : Any]
        endAddress = self.riderInfo!["end_address"] as? [String : Any]
        
        pickUpAddress.text = "\(String(describing: startAddress!["street"]!)), \(String(describing: startAddress!["city"]!))\t\(String(describing: startAddress!["postal_code"]!)))"
        
        Destination.text = "\(String(describing: endAddress!["street"]!)), \(String(describing: endAddress!["city"]!))\t\(String(describing: endAddress!["postal_code"]!))"
        
        date.text = "\(String(describing: rideDate!))"
    
        let rating = Int(driverRating!)
       
        starArray = [ratingStar1, ratingStar2, ratingStar3, ratingStar4, ratingStar5]
        
        let num = rating - 1
        if(num > 0){
            for index in 0...num {
                starArray[index].image = UIImage(named: "FilledStar.png")
            }
        }
        
    }
}
