//
//  DriverChangePasswordViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordItem: UINavigationItem!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var change: UILabel!
    @IBOutlet weak var confirmNewPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var currentPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("password", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        confirm.text = NSLocalizedString("confirmNewPass", comment: "")
        new.text = NSLocalizedString("newPassword", comment: "")
        current.text = NSLocalizedString("currentPassword", comment: "")
        change.text = NSLocalizedString("changePassword", comment: "")
    }
    
    @IBAction func cangePasswordButton(_ sender: Any) {
        //version 2
        
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       currentPassword.resignFirstResponder()
        newPassword.resignFirstResponder()
        confirmNewPassword.resignFirstResponder()
        return false
    }
    
}
