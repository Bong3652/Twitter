//
//  LoginViewController.swift
//  Twitter
//
//  Created by APPLE on 1/28/19.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "LoggedIn") {
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }
    }
    
    @IBAction func didLogin(_ sender: UIButton) {
        let loginUrl = "https://api.twitter.com/oauth/request_token"
        TwitterAPICaller.client?.login(url: loginUrl, success: {
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            self.performSegue(withIdentifier: "LoginSegue", sender: self)
        }, failure: { (Error) in
            print("Could not login")
        })
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
