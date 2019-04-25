//
//  LoginSplashScreenViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import RealmSwift

class LoginSplashScreenViewController: ViewController {

    var name : String?
    var userType : String?
    var rider: Rider?
    var driver: Driver?
    
    @IBOutlet weak var welcome: UILabel!
    @IBOutlet weak var nameText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcome.text = NSLocalizedString("welcome", comment: "")
        nameText.text = name
        perform(#selector(goToMainView), with: nil, afterDelay: 3.0)
        
    
    }
    
    @objc func goToMainView () {
         //It uses the segue in order to go to the next page, tableview
        
        if userType == "Rider" {
            performSegue(withIdentifier: "RiderViewSegue", sender: self)
        } else {
            performSegue(withIdentifier: "DriverViewSegue", sender: self)
        }
    }

}
