//
//  DriverOptionsViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-23.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverOptionsViewController: ViewController {

    var driverInfo: DriverInfo?
    
    var descriptionDetails: String?
    var wheel_Chair: Bool?
    var big_Truck: Bool?
    var physical_Assistance: Bool?
    var other: Bool?
    
    @IBOutlet weak var accessibility: UINavigationItem!
    @IBOutlet weak var wheelchair_accessible: CheckmarkButton!
    @IBOutlet weak var big_trunk: CheckmarkButton!
    @IBOutlet weak var physical_assistance: CheckmarkButton!
    @IBOutlet weak var other_requests: CheckmarkButton!
    @IBOutlet weak var options: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var wheel: UILabel!
    @IBOutlet weak var big: UILabel!
    @IBOutlet weak var physical: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("accessible", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        options.text = NSLocalizedString("accessibilityOptions", comment: "")
        wheel.text = NSLocalizedString("wheelchair", comment: "")
        big.text = NSLocalizedString("trunk", comment: "")
        physical.text = NSLocalizedString("physical", comment: "")
        otherLabel.text = NSLocalizedString("other", comment: "")
        message.text = NSLocalizedString("accessibleMesage", comment: "")
    }

    
    
    @IBAction func Finish_Button(_ sender: Any) {
        
        wheel_Chair = wheelchair_accessible.isChecked()
        big_Truck = big_trunk.isChecked()
        physical_Assistance = physical_assistance.isChecked()
        other = other_requests.isChecked()
        
        driverInfo?.addAccessibility(wheelChair: wheel_Chair!, physicalAssistance: physical_Assistance!, bigTruck: big_Truck!, other: other!)
  
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DescriptionSegue" {
            let driverDescriptionController = segue.destination as? DriverDescriptionViewController
            driverDescriptionController?.driverInfo = driverInfo
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
