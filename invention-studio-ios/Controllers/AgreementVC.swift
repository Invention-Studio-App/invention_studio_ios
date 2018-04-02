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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func agreementSigned(_ sender: Any) {
        self.performSegue(withIdentifier: "agreementSignedSegue", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "agreementSignedSegue" {
            let weekInterval: TimeInterval = 60 * 60 * 24 * 7
            //TODO: Use server time
            UserDefaults.standard.set(NSDate().addingTimeInterval(weekInterval).timeIntervalSince1970, forKey:"LoginSession")
            let username = UserDefaults.standard.string(forKey: "Username")!
            Messaging.messaging().subscribe(toTopic: username)
        }
    }

}
