//
//  DriverPaymentsDetailsViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverPaymentsDetailsViewController: UIViewController {
    @IBOutlet weak var riderPhoto: UIImageView!
    @IBOutlet weak var recieverAmount: UITextView!
    @IBOutlet weak var detailsItem: UINavigationItem!
    @IBOutlet weak var rider: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var paymentsDate: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.title = NSLocalizedString("details", comment: "")
        rider.text = NSLocalizedString("rider", comment: "")
        payment.text = NSLocalizedString("paymentRecieved", comment: "")
        date.text = NSLocalizedString("date", comment: "")
    }
    
    //version 2
}
