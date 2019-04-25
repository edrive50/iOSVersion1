//
//  RiderRegisterOptionsViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderRegisterOptionsViewController: ViewController,  UITextFieldDelegate {
    
    var riderInfo: RiderInfo?
    var emergencyName = ""
    var emergencyPhone = ""
    
    var wheelChair: Bool?
    var bigTruck: Bool?
    var physicalAssistance: Bool?
    var other: Bool?
    
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var famOptional: UILabel!
    @IBOutlet weak var family: UILabel!
    @IBOutlet weak var otherLabel: UILabel!
    @IBOutlet weak var physical: UILabel!
    @IBOutlet weak var big: UILabel!
    @IBOutlet weak var wheel: UILabel!
    @IBOutlet weak var optional: UILabel!
    @IBOutlet weak var special: UILabel!
    @IBOutlet weak var accessibility: UINavigationItem!
    
    @IBOutlet weak var EmergencyName: UITextField!
    
    @IBOutlet weak var EmergencyNumber: UITextField!
    @IBOutlet weak var physicalAssistanceMark: CheckmarkButton!
    
    @IBOutlet weak var otherCheckMark: CheckmarkButton!
    @IBOutlet weak var wheelchairCheckMark: CheckmarkButton!
    @IBOutlet weak var bigtruckCheckMark: CheckmarkButton!
    
    @IBAction func PaymentButton(_ sender: Any) {
        
        emergencyName = EmergencyName.text!
        emergencyPhone = EmergencyNumber.text!
        wheelChair = wheelchairCheckMark.isChecked()
        bigTruck = bigtruckCheckMark.isChecked()
        physicalAssistance = physicalAssistanceMark.isChecked()
        other = otherCheckMark.isChecked()
        
        riderInfo?.addAccessibility(wheelChair: wheelChair!, physicalAssistance: physicalAssistance!, bigTruck: bigTruck!, other: other!)
        
        riderInfo?.addEmergencyContact(emergencyName: emergencyName, emergencyNumber: emergencyPhone)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("accessible", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        optional.text = NSLocalizedString("optional", comment: "")
        special.text = NSLocalizedString("Special", comment: "")
        wheel.text = NSLocalizedString("wheelchair", comment: "")
        big.text = NSLocalizedString("trunk", comment: "")
        physical.text = NSLocalizedString("physical", comment: "")
        otherLabel.text = NSLocalizedString("other", comment: "")
        famOptional.text = NSLocalizedString("optional", comment: "")
        nameLabel.text = NSLocalizedString("name", comment: "")
        phone.text = NSLocalizedString("phone", comment: "")
        family.text = NSLocalizedString("family", comment: "")
        
        EmergencyNumber.delegate = self
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        EmergencyName.resignFirstResponder()
        EmergencyNumber.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PayOptionsSegue" {
            let payOptionsController = segue.destination as? RiderRegisterPayOptionsViewController
            payOptionsController?.riderInfo = riderInfo
            
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
