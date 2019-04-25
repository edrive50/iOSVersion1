//
//  RiderSpecialRequirementViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderSpecialRequirementViewController: UIViewController {
    
    @IBOutlet weak var accessibilityItem: UINavigationItem!
    @IBOutlet weak var wheel: UILabel!
    @IBOutlet weak var special: UILabel!
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var physical: UILabel!
    @IBOutlet weak var big: UILabel!
    @IBOutlet weak var save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("accessible", comment: "")
        wheel.text = NSLocalizedString("wheelchair", comment: "")
        special.text = NSLocalizedString("Special", comment: "")
        other.text = NSLocalizedString("other", comment: "")
        physical.text = NSLocalizedString("physical", comment: "")
        big.text = NSLocalizedString("trunk", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
    }
    
    @IBAction func specialrequirementButton(_ sender: Any) {
        //version 2
    }
}
