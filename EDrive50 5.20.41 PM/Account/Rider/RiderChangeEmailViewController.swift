//
//  RiderChangeEmailViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderChangeEmailViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var confirmRiderNewEmail: UITextField!
    @IBOutlet weak var riderEmail: UITextField!
    @IBOutlet weak var riderNewEmail: UITextField!
    @IBOutlet weak var changeEmail: UILabel!
    @IBOutlet weak var currentEmail: UILabel!
    @IBOutlet weak var newEmail: UILabel!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var emailItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("email", comment: "")
        changeEmail.text = NSLocalizedString("changeEmail", comment: "")
        currentEmail.text = NSLocalizedString("currentEmail", comment: "")
        newEmail.text = NSLocalizedString("newEmail", comment: "")
        confirm.text = NSLocalizedString("confirmNewEmail", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
    }
    @IBAction func saveRiderEmail(_ sender: Any) {
        //version 2
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       riderEmail.resignFirstResponder()
        riderNewEmail.resignFirstResponder()
        confirmRiderNewEmail.resignFirstResponder()
        return false
    }
    
}
