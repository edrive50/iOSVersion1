//
//  RiderChangePasswordViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderChangePasswordViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var newPasswordConfirm: UITextField!
    @IBOutlet weak var riderNewPassword: UITextField!
    @IBOutlet weak var riderCurrentPassword: UITextField!
    @IBOutlet weak var passwordItem: UINavigationItem!
    @IBOutlet weak var changePassword: UILabel!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var current: UILabel!
    @IBOutlet weak var confirmNew: UILabel!
    @IBOutlet weak var save: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("password", comment: "")
        changePassword.text = NSLocalizedString("changePassword", comment: "")
        current.text = NSLocalizedString("currentPassword", comment: "")
        new.text = NSLocalizedString("newPassword", comment: "")
        confirmNew.text = NSLocalizedString("confirmNewPassword", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
    }
    @IBAction func changePasswordButton(_ sender: Any) {
        //version 2
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        riderCurrentPassword.resignFirstResponder()
        riderNewPassword.resignFirstResponder()
        newPasswordConfirm.resignFirstResponder()
    
        return false
    }
    
}
