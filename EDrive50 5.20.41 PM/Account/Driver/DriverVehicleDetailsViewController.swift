//
//  DriverVehicleDetailsViewController.swift
//  edrive50
//
//  Created by Oluwakemi Mafe on 2019-04-08.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverVehicleDetailsViewController: UIViewController {

    @IBOutlet weak var vehicledetails: UILabel!
    @IBOutlet weak var make: UILabel!
    @IBOutlet weak var detailsIyem: UINavigationItem!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var colour: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var model: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("details", comment: "")
        save.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        vehicledetails.text = NSLocalizedString("vehicleDetails", comment: "")
        make.text = NSLocalizedString("make", comment: "")
        year.text = NSLocalizedString("year", comment: "")
        colour.text = NSLocalizedString("colour", comment: "")
        type.text = NSLocalizedString("type", comment: "")
        model.text = NSLocalizedString("model", comment: "")
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
