//
//  WaitForAuthorizationViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class WaitForAuthorizationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        perform(#selector(goToLoginView), with: nil, afterDelay: 3.0)
        // Do any additional setup after loading the view.
    }
    
    @objc func goToLoginView() {
        performSegue(withIdentifier: "ToLoginScreenSegue", sender: self)
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
