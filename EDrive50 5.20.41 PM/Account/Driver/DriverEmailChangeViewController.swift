//
//  DriverEmailChangeViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverEmailChangeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailItem: UINavigationItem!
    
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var confirmEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var currentEmail: UITextField!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var save: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("email", comment: "")
        confirm.text = NSLocalizedString("confirmNewEmail", comment: "")
        new.text = NSLocalizedString("newEmail", comment: "")
        current.text = NSLocalizedString("currentEmail", comment: "")
        change.text = NSLocalizedString("changeEmail", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        // Do any additional setup after loading the view.
    }
    @IBAction func saveEmailChange(_ sender: Any) {
        //version 2
        
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       currentEmail.resignFirstResponder()
        newEmail.resignFirstResponder()
        confirmEmail.resignFirstResponder()
        return false
    }
    
}
