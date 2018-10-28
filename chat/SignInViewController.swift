//
//  SignInViewController.swift
//  chat
//
//  Created by kobi on 13/08/2017.
//  Copyright © 2017 Kobi Kanetti. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func signInAction(_ sender: Any) {
        
        guard let email = emailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print(error)
                //TODO - toast
                return
            }
            
            FlowController.shared.determineRoot()
        }
    }



}
