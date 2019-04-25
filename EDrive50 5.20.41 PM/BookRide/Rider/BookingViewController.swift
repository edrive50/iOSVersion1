//
//  BookingViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class BookingViewController: UIViewController {
    
    @IBOutlet weak var PickUpAddressLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var nowButton: UIButton!
    @IBOutlet weak var laterButton: UIButton!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var bookWhen: UILabel!
    @IBOutlet weak var timeItem: UINavigationItem!
    
    var placeA : Place?
    var placeB : Place?
    var riderObj : [String : Any] = [:]
    var riderInfo : [String : Any] = [:]
    var start_address : [String : Any] = [:]
    var end_address : [String : Any] = [:]
    var accessibility_options : [String : Any] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("time", comment: "")
        pickUp.text = NSLocalizedString("pickUp", comment: "")
        destination.text = NSLocalizedString("destination", comment: "")
        bookWhen.text = NSLocalizedString("bookWhen", comment: "")
        nowButton.setTitle(NSLocalizedString("now", comment: ""), for: .normal)
        laterButton.setTitle(NSLocalizedString("later", comment: ""), for: .normal)
        
        PickUpAddressLabel.text = placeA?.address
        DestinationLabel.text = placeB?.address
        
    }
    
    @IBAction func laterButtonTapped(_ sender: Any) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //checking segue identifier
        if segue.identifier == "SpecialRequestsSegue" {
            let nextController = segue.destination as! SpecialRequestsViewController
            nextController.placeA = placeA
            nextController.placeB = placeB
        } else {
            let nextController = segue.destination as! RideSchedulingViewController
            nextController.placeA = placeA
            nextController.placeB = placeB

        }
        
    }
}
