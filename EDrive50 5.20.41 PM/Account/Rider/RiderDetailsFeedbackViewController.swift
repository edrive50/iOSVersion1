//
//  DriverDetailsFeedbackViewController.swift
//  edrive50
//
//  Created by Admin on 2019-04-01.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderDetailsFeedbackViewController: UIViewController {
    
    
    
    @IBAction func buttonTappded(_ sender: UIButton) {
        
        print("Rated \(sender.tag) stars.")
        
        for button in starButtons {
            
            if button.tag <= sender.tag {
                button.setBackgroundImage(UIImage.init(named: "StarFilled"), for: .normal)
            }
            else{
                button.setBackgroundImage(UIImage.init(named: "StarEmpty"), for: .normal)
            }
        }
    }
    @IBOutlet weak var driverName: UITextView!
    @IBOutlet var starButtons: [UIButton]!
    @IBOutlet weak var rideDate: UITextView!
    
    @IBOutlet weak var driverPhoto: UIImageView!
    @IBOutlet weak var riderDestination: UITextView!
    @IBOutlet weak var riderPickup: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
