//
//  DriverAccountViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class RiderAccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var accountItem: UINavigationItem!
    
    var RiderAccountOptions = [String]()
    var segueIdentifiers = ["showProfile","showHistory","showPayments","showAbout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RiderAccountOptions = [NSLocalizedString("profile", comment: ""),NSLocalizedString("history", comment: ""),NSLocalizedString("payments", comment: ""),NSLocalizedString("about", comment: "")]
        self.title = NSLocalizedString("account", comment: "")
        logoutButton.setTitle(NSLocalizedString("logOut", comment: ""), for: .normal)
       logoutButton.becomeFirstResponder()
    
    }
    
    @IBAction func riderLogoutButton(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RiderAccountOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")! as UITableViewCell
        cell.textLabel?.text = RiderAccountOptions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
    }
}
