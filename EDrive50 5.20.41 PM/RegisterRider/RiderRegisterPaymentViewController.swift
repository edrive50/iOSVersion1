//
//  RiderRegisterPaymentViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderRegisterPaymentViewController: ViewController,  UITextFieldDelegate {
    var riderInfo: RiderInfo?
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expiryDateField: UITextField!
    @IBOutlet weak var CVVField: UITextField!
    @IBOutlet weak var cardholderNameField: UITextField!
    @IBOutlet weak var cardNum: UILabel!
    @IBOutlet weak var expiry: UILabel!
    @IBOutlet weak var holder: UILabel!
    @IBOutlet weak var paymentItem: UINavigationItem!
    @IBOutlet weak var finish: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("payment", comment: "")
        cardNum.text = NSLocalizedString("cardNum", comment: "")
        expiry.text = NSLocalizedString("expiry", comment: "")
        holder.text = NSLocalizedString("cardName", comment: "")
        finish.setTitle(NSLocalizedString("finish", comment: ""), for: .normal)
        
        cardholderNameField.delegate = self
    }
    
    // Card Buttons Go Here
    
    @IBAction func FinishButton(_ sender: Any) {
        if !(cardNumberField.text?.isEmpty)! && !(expiryDateField.text?.isEmpty)! && !(CVVField.text?.isEmpty)! && !(cardholderNameField.text?.isEmpty)! {
            // dummy data sent if all fields there
            riderInfo?.addCardDetails(cardNumber: cardNumberField.text!, expiryDate: expiryDateField.text!, cvv: Int(CVVField.text!)!, cardHolderName: cardholderNameField.text!)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FinishRegisterPaymentSegue" {
            let payOptionsController = segue.destination as? LoginSplashScreenViewController
            payOptionsController?.name = (riderInfo?.name)!
            payOptionsController?.userType = "Rider"
        }
    }

    //this code runs when someone touches the screeen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cardNumberField.resignFirstResponder()
        expiryDateField.resignFirstResponder()
        CVVField.resignFirstResponder()
        cardholderNameField.resignFirstResponder()

        return false
    }
    
}
