//
//  AgreementVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 2/18/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import FirebaseMessaging

class AgreementVC: ISViewController {

    var errorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func agreementSigned(_ sender: Any) {
        let form = LoginForm()
        if let username = UserDefaults.standard.string(forKey: "Username") {
            Messaging.messaging().subscribe(toTopic: "\(username)_ios")

            form.user_username = username
        }
        if let name = UserDefaults.standard.string(forKey: "Name") {
            form.user_name = name
        }
        if let apiKey = UserDefaults.standard.string(forKey: "UserKey") {
            form.api_key = apiKey
        }

        let loginEvalGroup = DispatchGroup()
        var responseMessage = ""
        loginEvalGroup.enter()
        InventionStudioApi.User.login(form: form, completion: { message in
            responseMessage = message
            loginEvalGroup.leave()
        })

        loginEvalGroup.notify(queue: .main, execute: {
            let parts = responseMessage.components(separatedBy: ":")
            if parts[0] == "Login Error" {
                self.errorMessage = responseMessage
                self.performSegue(withIdentifier: "cancelAgreementSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "agreementSignedSegue", sender: self)
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "agreementSignedSegue" {
            UserDefaults.standard.set(true, forKey: "LoggedIn")
            let weekInterval: TimeInterval = 60 * 60 * 24 * 7
            //TODO: Use server time
            UserDefaults.standard.set(NSDate().addingTimeInterval(weekInterval).timeIntervalSince1970, forKey:"LoginSession")
        }
    }

}
