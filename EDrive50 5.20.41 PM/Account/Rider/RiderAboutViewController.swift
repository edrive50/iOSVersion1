//
//  DriverAboutViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderAboutViewController: UIViewController {

    
    @IBOutlet weak var aboutItem: UINavigationItem!
    @IBOutlet weak var aboutInfo: UITextView!
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var termsOfUse: UILabel!
    @IBOutlet weak var termsMessage: UITextView!
    @IBOutlet weak var termsOfServiceBtn1: UIButton!
    @IBOutlet weak var termsOfServiceBtn2: UIButton!
    @IBOutlet weak var privacyMessage: UITextView!
    @IBOutlet weak var privacy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("about", comment: "")
        aboutInfo.text = NSLocalizedString("aboutInfo", comment: "")
        contact.text = NSLocalizedString("contact", comment: "")
        termsOfUse.text = NSLocalizedString("termOfUse", comment: "")
        termsMessage.text = NSLocalizedString("termsMessage", comment: "")
        privacy.text = NSLocalizedString("privacy", comment: "")
        privacyMessage.text = NSLocalizedString("privacyMessage", comment: "")
        termsOfServiceBtn1.setTitle(NSLocalizedString("googleTerms", comment: ""), for: .normal)
        termsOfServiceBtn2.setTitle(NSLocalizedString("googleTerms", comment: ""), for: .normal)
    }
    
    @IBAction func termsOfService1(_ sender: Any) {
        if let url = URL(string: "http://policies.google.com/terms?hl=en") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
    @IBAction func termsOfService2(_ sender: Any) {
        if let url = URL(string: "http://policies.google.com/terms?hl=en") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
    
}
