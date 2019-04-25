//
//  SpecialRequestsViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class SpecialRequestsViewController: UIViewController {
    @IBOutlet weak var PickupAddressLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var WheelchairBox: CheckmarkButton!
    @IBOutlet weak var BigTrunkBox: CheckmarkButton!
    @IBOutlet weak var PhysicalAssistanceBox: CheckmarkButton!
    @IBOutlet weak var OtherBox: CheckmarkButton!
    @IBOutlet weak var dateAndTime: UILabel!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var pickUpTime: UILabel!
    @IBOutlet weak var specialRequest: UILabel!
    @IBOutlet weak var wheelchailrLabel: UILabel!
    @IBOutlet weak var bigTrunkLabel: UILabel!
    @IBOutlet weak var physicalLabel: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var findDriverBtn: UIButton!
    @IBOutlet weak var accessibilityItem: UINavigationItem!
    
    var placeA : Place?
    var placeB : Place?
    var wheelchair: Bool?
    var bigTrunk: Bool?
    var physicalAssistance: Bool?
    var other: Bool?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("accessible", comment: "")
        pickUp.text = NSLocalizedString("pickUp", comment: "")
        destination.text = NSLocalizedString("destination", comment: "")
        pickUpTime.text = NSLocalizedString("time", comment: "")
        wheelchailrLabel.text = NSLocalizedString("wheelchair", comment: "")
        bigTrunkLabel.text = NSLocalizedString("trunk", comment: "")
        physicalLabel.text = NSLocalizedString("physical", comment: "")
        otherLabel.text = NSLocalizedString("other", comment: "")
        findDriverBtn.setTitle(NSLocalizedString("findDriver", comment: ""), for: .normal)
        specialRequest.text = NSLocalizedString("Special", comment: "")
        
        PickupAddressLabel.text = placeA?.address
        DestinationLabel.text = placeB?.address
        dateAndTime.text = "Now"
        
        let realm = try! Realm()
        let r = realm.objects(Rider.self).first
        
        WheelchairBox.setChecked(r!.wheelchair)
        BigTrunkBox.setChecked(r!.big_truck)
        PhysicalAssistanceBox.setChecked(r!.physical_assistance)
        OtherBox.setChecked(false)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func FindDriver(_ sender: Any) {
        wheelchair = WheelchairBox.isChecked()
        bigTrunk = BigTrunkBox.isChecked()
        physicalAssistance = PhysicalAssistanceBox.isChecked()
        other = OtherBox.isChecked()
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! DriverListViewController
        nextController.placeA = placeA
        nextController.placeB = placeB
    }

}
