//
//  ViewController.swift
//  FirebaseLoginJuly
//
//  Created by Daniel Hjärtström on 2018-07-11.
//  Copyright © 2018 Daniel Hjärtström. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController2: UIViewController {

    private lazy var facebookLoginButton: FBSDKLoginButton = {
        let temp = FBSDKLoginButton()
        temp.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60.0)
        temp.delegate = self
        return temp
    }()
    
    private lazy var customFacebookLoginButton: CustomFacebookLoginButton = {
        let temp = CustomFacebookLoginButton(type: .system)
        temp.frame = CGRect(x: 0, y: 100.0, width: view.frame.width, height: 60.0)
        temp.backgroundColor = UIColor.blue
        temp.setTitle("Login with Facebook", for: .normal)
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.0)
        temp.addTarget(self, action: #selector(customFacebookLogin(_:)), for: .touchUpInside)
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(facebookLoginButton)
        view.addSubview(customFacebookLoginButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController2: FBSDKLoginButtonDelegate {
    
    @objc private func customFacebookLogin(_ sender: CustomFacebookLoginButton) {
        
        if !sender.isLoggedIn {
            FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
                guard error == nil else {
                    print("Login request failed with error -- \(error?.localizedDescription ?? "No error")")
                    return
                }
                
                print(result?.token.tokenString!)
                self.getUserData()
                sender.isLoggedIn = true
                sender.setTitle("Logout from Facebook", for: .normal)
            }
        } else {
            FBSDKLoginManager().logOut()
            sender.isLoggedIn = false
            sender.setTitle("Login with Facebook", for: .normal)

        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Logged out from Facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        print("Logged in with Facebook")
        getUserData()
    }
    
    private func getUserData() {
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "id, name, email"]).start { (connection, result, error) in
            guard error == nil else {
                print("Graph request failed with error -- \(error?.localizedDescription ?? "No error")")
                return
            }
            print(result as! [String:String])
        }
    }
    
}

