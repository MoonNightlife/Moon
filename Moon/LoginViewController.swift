//
//  ViewController.swift
//  Moon
//
//  Created by Evan Noble on 4/16/17.
//  Copyright © 2017 Evan Noble. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: TextField!
    @IBOutlet weak var passwordTextField: TextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var keyIcon: UIImageView!
    @IBOutlet weak var orIcon: UIImageView!
    @IBOutlet weak var recoverButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        setUpLoginView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        let searchController = SearchBarViewController(rootViewController: MasterViewController.instantiateFromStoryboard())
//        self.present(searchController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpLoginView() {
        
        //Email Text Field Set Up
        emailTextField.dividerNormalColor = .moonBlue
        emailTextField.dividerActiveColor = .moonBlue
        emailTextField.placeholder = "email"
        emailTextField.placeholderActiveColor = .moonBlue
        emailTextField.placeholderNormalColor = .lightGray
        emailTextField.textColor = .black
        
        //Password Text Field Set Up
        passwordTextField.dividerNormalColor = .moonBlue
        passwordTextField.dividerActiveColor = .moonBlue
        passwordTextField.placeholder = "password"
        passwordTextField.placeholderActiveColor = .moonBlue
        passwordTextField.placeholderNormalColor = .lightGray
        passwordTextField.textColor = .black
        
        //Login Button Set Up
        loginButton.backgroundColor = .moonBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        
        //Sign Up Button Set Up
        signUpButton.backgroundColor = .moonGreen
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.layer.cornerRadius = 5
        
        //Recover Button Set Up
        recoverButton.setTitleColor(.moonPurple, for: .normal)
        
        emailIcon.image = emailIcon.image?.withRenderingMode(.alwaysTemplate)
        emailIcon.tintColor = .moonBlue
        
        keyIcon.image = keyIcon.image?.withRenderingMode(.alwaysTemplate)
        keyIcon.tintColor = .moonBlue
        
        orIcon.image = orIcon.image?.withRenderingMode(.alwaysTemplate)
        orIcon.tintColor = .lightGray
    }
}
