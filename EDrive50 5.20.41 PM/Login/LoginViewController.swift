//
//  LoginViewController.swift
//  edrive50
//
//  Created by Suuba Magai on 2019-03-20.
//  Copyright © 2019 Suuba Magai. All rights reserved.
//

import UIKit
import SwiftyJSON
import RealmSwift


class LoginViewController: ViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var keepMeSignedIn: UILabel!
    @IBOutlet weak var forgotPassword: UILabel!
    @IBOutlet weak var signUp: UIButton!
    @IBOutlet weak var pageName: UINavigationItem!
    @IBOutlet weak var loginBtn: UIButton!
    
    var email : String?
    var password : String?
    var user_type : String?
    var lang = "En"
    
    var name = "Bob" // temp
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("login", comment: "")
        emailLabel.text = NSLocalizedString("email", comment: "")
        passwordLabel.text = NSLocalizedString("password", comment: "")
        keepMeSignedIn.text = NSLocalizedString("keep", comment: "")
        forgotPassword.text = NSLocalizedString("forgot", comment: "")
        signUp.setTitle(NSLocalizedString("signUp", comment: ""), for: .normal)
        loginBtn.setTitle(NSLocalizedString("login", comment: ""), for: .normal)
        
        passwordField.delegate = self

        if UserDefaults.standard.bool(forKey: "isLoggedIn") == true {
            let email = UserDefaults.standard.string(forKey: "email")
            let password = UserDefaults.standard.string(forKey: "password")
            let POSTUrl = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/login")!
            var POSTrequest = URLRequest(url: POSTUrl)
            POSTrequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            POSTrequest.httpMethod = "POST"
            let postString = "email=\(email!)&password=\(password!)" // which is your parameters
            POSTrequest.httpBody = postString.data(using: .utf8)
            
            let POSTtask = URLSession.shared.dataTask(with: POSTrequest, completionHandler: requestTask);
            POSTtask.resume()
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func LoginButton(_ sender: Any) {
        
        sendLoginInfoToServer()
    }
    
    @IBAction func FacebookLoginButton(_ sender: Any) {
        
        //not yet implemented
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
    }
    
    @IBAction func enBtnTapped(_ sender: Any) {
        //not implemented
    }
    
    @IBAction func frBtnTapped(_ sender: Any) {
        //not implemented
    }
    func sendLoginInfoToServer(){
        
        email = emailField!.text
        password = passwordField!.text
        
        // Check of email is not empty
        if isStringEmpty(stringValue: email!) == true || isStringEmpty(stringValue: password!) == true {
            print("here")
            let alert = UIAlertController(title: "Alert", message: "Email and/or Password not set", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
        }
        
        // Send HTTP POST Request
        let POSTUrl = URL(string: "http://ec2-13-58-133-172.us-east-2.compute.amazonaws.com:3000/app/login")!
        var POSTrequest = URLRequest(url: POSTUrl)
        POSTrequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        POSTrequest.httpMethod = "POST"
        let postString = "email=\(email!)&password=\(password!)" // which is your parameters
        POSTrequest.httpBody = postString.data(using: .utf8)
        
        let POSTtask = URLSession.shared.dataTask(with: POSTrequest, completionHandler: requestTask);
        POSTtask.resume()
    }
    
    func requestTask(_ serverData: Data?, serverResponse: URLResponse?, serverError:Error?) -> Void {
        
        // Check if an error occured, and if not take the data recieved from the server and process it
        if serverError != nil {
            // Send en empty string as the data, and the error to the callback function
            self.POSTCallBack(responseString: "", error: serverError?.localizedDescription)
        }
        else {
            // Stringfy the response data
            let result = String(data: serverData!, encoding: String.Encoding.utf8)!
            // Send the response string data, and nil for the error tot he callback
            self.POSTCallBack(responseString: result as String, error:nil)
        }
    }
    
    // Define the callback function to be triggered when the response is recieved
    func POSTCallBack(responseString: String, error: String?) {
        // If the server request generated an error then handle it
        if error != nil {
            print("ERROR is " + error!)
        } else {
            print(responseString)
            
            if let myData: Data = responseString.data(using: String.Encoding.utf8) {
                do {
                     let obj = try JSON(data: myData)
                    // Try to convert response data into a dictionary to be save into the jsonDictionary optional dictionary variable
                    let message = obj["message"].string
                    let auth = obj["auth"].boolValue
                    
                    user_type = obj["user_type"].string
                    
                    if user_type == "Driver" {
                        let d = Driver()
                        let driver = d.makeDriver(obj: obj, token: obj["token"].string!, language:lang)

                        if d.count() > 0 {
                            d.delete(driver: driver)
                            d.save(driver: driver)
                        } else {
                            d.save(driver: driver)
                        }
                    } else if user_type == "Rider" {
                        let r = Rider()
                        let rider = r.makeRider(obj: obj, token: obj["token"].string!, language:lang)

                        if r.count() > 0 {
                            r.delete(rider: rider)
                            r.save(rider: rider)
                        } else {
                            r.save(rider: rider)
                        }
                    }

                    if auth {
                        if email != nil {
                            UserDefaults.standard.set(email, forKey: "email")
                            UserDefaults.standard.set(password, forKey: "password")
                        }
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        name = obj["data"]["name"].string!
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SplashScreenSegue", sender: self)
                        }
                    } else {

                        let alert = UIAlertController(title: "Alert", message: message!, preferredStyle: .alert)
                        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(ok)
                        present(alert, animated: true, completion: nil)
                    }
                    //getName()
                } catch let convertError {
                    // If it fails catch the error info
                    print(convertError.localizedDescription)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SignUpSegue" {

        } else if segue.identifier == "SplashScreenSegue" {
            let loginSplashController = segue.destination as? LoginSplashScreenViewController
            loginSplashController?.name = name
            loginSplashController?.userType = user_type
        }
    }
    
    func isStringEmpty(stringValue:String) -> Bool {
        var returnValue = false
        
        if stringValue.isEmpty  == true {
            returnValue = true
            return returnValue
        }
        
        if(stringValue.isEmpty == true){
            returnValue = true
            return returnValue
        }
        
        return returnValue
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true) //this works for any text element
    }
    
    //this func is used to interact with the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        if textField.accessibilityIdentifier! == "password"{
            sendLoginInfoToServer()
        }
        
        return true
    }

}

