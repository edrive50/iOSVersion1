//
//  RiderPaymentDetailsViewController.swift
//  edrive50
//
//  Created by Oluwakemi Mafe on 2019-04-21.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderPaymentDetailsViewController: UIViewController {

    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var detailsItem: UINavigationItem!
    @IBOutlet weak var amountPaid: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var drivenBy: UILabel!
    
    var starArray = [UIImageView]()
    var driverRating = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

       self.title = NSLocalizedString("details", comment: "")
        amountPaid.text = NSLocalizedString("amountPaid", comment: "")
        dateLabel.text = NSLocalizedString("date", comment: "")
        
        starArray = [star1, star2, star3, star4, star5]
        
        let num = driverRating - 1
        if(num > 0){
            for index in 0...num {
                starArray[index].image = UIImage(named: "FilledStar.png")
            }
        }
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
