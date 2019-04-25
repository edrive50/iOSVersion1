//
//  RideSchedulingViewController.swift
//  edrive50
//
//  Created by Oluwakemi Mafe on 2019-04-05.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RideSchedulingViewController: UIViewController {

    @IBOutlet weak var pickupAddress: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var pickupDateAndTime: UIDatePicker!
    @IBOutlet weak var scheduleItem: UINavigationItem!
    @IBOutlet weak var pickUp: UILabel!
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pickUpTime: UILabel!
    
    var time:String?
    var placeA : Place?
    var placeB : Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("schedule", comment: "")
        pickUp.text = NSLocalizedString("pickUp", comment: "")
        destination.text = NSLocalizedString("destination", comment: "")
        pickUpTime.text = NSLocalizedString("time", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        
        pickupAddress.text = placeA?.address
        destination.text = placeB?.address
        time = String(pickupDateAndTime.date.description.dropLast(9))
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextController = segue.destination as! RideScheduleRequestViewController
        nextController.placeA = placeA!
        nextController.placeB = placeB!
        nextController.time = time!
        nextController.rideTime = pickupDateAndTime.date
        nextController.date = toMillis(date: pickupDateAndTime.date)
        
    }
    
    func toMillis(date: Date)-> Int64!{
        return Int64(date.timeIntervalSince1970 * 1000)
    }

}
