//
//  DriverRegisterAccountViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-23.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit


class DriverRegisterAccountViewController: ViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var driverInfo: DriverInfo?
    
    var driverConfirmPassword = ""
    var driverPassword = ""
    var emailAddress = ""
    var phoneNumber = ""
    var driverName = ""
    var imagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var regRider: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var confirm: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var personalItem: UINavigationItem!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var chooseImage: UIButton!
    @IBOutlet weak var DriverPhoneNumber: UITextField!
    @IBOutlet weak var DriverName: UITextField!
    @IBOutlet weak var DriverEmail: UITextField!
    @IBOutlet weak var DriverPassword: UITextField!
    @IBOutlet weak var DriverConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("personal", comment: "")
        profilePicture.isHidden = true
        // Do any additional setup after loading the view.
        regRider.setTitle(NSLocalizedString("registerRider", comment: ""), for: .normal)
        nextBtn.setTitle(NSLocalizedString("next", comment: ""), for: .normal)
        name.text = NSLocalizedString("name", comment: "")
        phone.text = NSLocalizedString("phone", comment: "")
        confirm.text = NSLocalizedString("confirmPass", comment: "")
        password.text = NSLocalizedString("password", comment: "")
        email.text = NSLocalizedString("eAddr", comment: "")
        profile.text = NSLocalizedString("ProfilePic", comment: "")
        
        DriverConfirmPassword.delegate = self

    }
    
    @IBAction func NextButton(_ sender: Any) {
        
        //CHECK PASSWORDS TO SEE IF MATCH
        driverPassword = DriverPassword.text!
        emailAddress = DriverEmail.text!
        phoneNumber = DriverPhoneNumber.text!
        driverName = DriverName.text!
        
        driverInfo = DriverInfo.init(name: driverName, password: driverPassword, email: emailAddress, phonenumber: phoneNumber)
        
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
            profilePicture.image = image
            chooseImage.isHidden = true
            profilePicture.isHidden = false
            
            print(image) //get the path to save in database
            
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in})
    }
    
//    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        DriverName.resignFirstResponder()
        DriverPhoneNumber.resignFirstResponder()
        DriverEmail.resignFirstResponder()
        DriverPassword.resignFirstResponder()
        DriverConfirmPassword.resignFirstResponder()
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OptionSegue" {
            let optionsController = segue.destination as? DriverOptionsViewController
            optionsController?.driverInfo = driverInfo
        }
    }

}
