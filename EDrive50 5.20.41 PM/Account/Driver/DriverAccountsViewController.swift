//
//  RiderAccountsViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit

class DriverAccountsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var logOut: UIButton!
    @IBOutlet weak var accountItem: UINavigationItem!
    
    var RiderAccountOptions = [String]()
    var segueIdentifiers = ["showProfile","showHistory","showAbout"]
    @IBOutlet weak var tableView: UITableView!
    @IBAction func driverLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("account", comment: "")
        RiderAccountOptions = [NSLocalizedString("profile", comment: ""), NSLocalizedString("history", comment: ""), NSLocalizedString("about", comment: "")]
        logOut.setTitle(NSLocalizedString("logOut", comment: ""), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RiderAccountOptions.count
    }
     
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("tab \(indexPath.row)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell")! as UITableViewCell
        cell.textLabel?.text = RiderAccountOptions[indexPath.row]
        return cell
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("segue \(indexPath.row)")
        performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
    }
}
