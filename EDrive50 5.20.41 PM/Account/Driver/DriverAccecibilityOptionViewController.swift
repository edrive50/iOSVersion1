//
//  DriverAccecibilityOptionViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverAccecibilityOptionViewController: UIViewController {

    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var physical: UILabel!
    @IBOutlet weak var other: UILabel!
    @IBOutlet weak var big: UILabel!
    @IBOutlet weak var wheel: UILabel!
    @IBOutlet weak var accessibility: UILabel!
    @IBOutlet weak var profileItem: UINavigationItem!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("accessible", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        physical.text = NSLocalizedString("physical", comment: "")
        other.text = NSLocalizedString("other", comment: "")
        big.text = NSLocalizedString("trunk", comment: "")
        wheel.text = NSLocalizedString("wheelchair", comment: "")
        accessibility.text = NSLocalizedString("accessibilityOptions", comment: "")
    }
    
    @IBAction func saveAccessibilityOptions(_ sender: Any) {
        //version 2
    }
}
