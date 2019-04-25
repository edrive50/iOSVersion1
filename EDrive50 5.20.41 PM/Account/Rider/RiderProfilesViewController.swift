//
//  DriverProfilesViewController.swift
//  edrive50
//
//  Created by Admin on 2019-03-27.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import RealmSwift

class RiderProfilesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var RiderAccountOptions = [String]()
    var segueIdentifiers = ["showChangeEmail","showChangePassword","showChangeSpecialRequests"]
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var riderImage: UIImageView!
    @IBOutlet weak var riderName: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var profileItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("profile", comment: "")
        RiderAccountOptions = [NSLocalizedString("changeEmail", comment: ""), NSLocalizedString("changePassword", comment: ""), NSLocalizedString("Special", comment: "")]
        changeBtn.setTitle(NSLocalizedString("change", comment: ""), for: .normal)
        tableView.delegate = self
        tableView.dataSource = self
        
        //REALM
        let realm = try! Realm()
        let r = realm.objects(Rider.self).first
        let rider_name = r!.name
        riderName.text = rider_name
     
    }
    
    @IBAction func imageChange(_ sender: Any) {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            riderImage.image = image
    
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: { () -> Void in})
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
