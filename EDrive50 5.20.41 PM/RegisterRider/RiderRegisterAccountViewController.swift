//
//  RiderCreateAccountViewController.swift
//  EDrive50
//
//  Created by Admin on 2019-03-03.
//  Copyright © 2019 Karandeep Dalam . All rights reserved.
//

import UIKit

class RiderRegisterAccountViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var confirmPassword = ""
    var aPassword = ""
    var eAddress = ""
    var pNumber = ""
    var fieldName = ""
    var riderInfo: RiderInfo?
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var personalItem: UINavigationItem!
    @IBOutlet weak var register: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var RiderName: UITextField!
    @IBOutlet weak var RidePhone: UITextField!
    @IBOutlet weak var RiderEmail: UITextField!
    @IBOutlet weak var RiderPassword: UITextField!
    @IBOutlet weak var RiderConfirmPassword: UITextField!
    @IBAction func NextButton(_ sender: Any) {
        
        
        aPassword = RiderPassword.text!
        confirmPassword = RiderConfirmPassword.text!
        eAddress = RiderEmail.text!
        pNumber = RidePhone.text!
        fieldName = RiderName.text!
        
        riderInfo = RiderInfo.init(name: fieldName, password: aPassword, email: eAddress, phonenumber: pNumber)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.isHidden = true
       
        self.title = NSLocalizedString("personal", comment: "")
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        register.setTitle(NSLocalizedString("registerDriver", comment: ""), for: .normal)
        password.text = NSLocalizedString("password", comment: "")
        confirm.text = NSLocalizedString("confirmPass", comment: "")
        email.text = NSLocalizedString("eAddr", comment: "")
        phone.text = NSLocalizedString("phone", comment: "")
        name.text = NSLocalizedString("name", comment: "")
        profile.text = NSLocalizedString("ProfilePic", comment: "")
        
        RiderConfirmPassword.delegate = self
    }
    
    @IBAction func chooseImageTapped(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImage.image = image
            chooseImage.isHidden = true
            profileImage.isHidden = false
            
            print(image) //get the path to save in database
            
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    
    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        RiderName.resignFirstResponder()
        RidePhone.resignFirstResponder()
        RiderEmail.resignFirstResponder()
        RiderPassword.resignFirstResponder()
        RiderConfirmPassword.resignFirstResponder()
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RegisterOptionsSegue" {
            let optionsController = segue.destination as? RiderRegisterOptionsViewController
            optionsController?.riderInfo = riderInfo
        }
    }
    
}
