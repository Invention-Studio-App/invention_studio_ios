//
//  LandingVC.swift
//  invention-studio-ios
//
//  Created by Noah Sutter on 1/21/18.
//  Copyright © 2018 Invention Studio at Georgia Tech. All rights reserved.
//

import UIKit
import FirebaseMessaging

class LandingVC: ISViewController {

    @IBOutlet weak var scrollView: UIScrollView!

    var errorMessage: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: "LoggedIn") {
            self.navigationItem.rightBarButtonItem = nil

            //Make sure new tab bar gets proper colors
            self.tabBarController?.tabBar.barTintColor = Theme.headerFooter
            self.tabBarController?.tabBar.unselectedItemTintColor = Theme.accentSecondary
            self.tabBarController?.tabBar.tintColor = Theme.accentPrimary
        }

        /**
         ** Set Up  View
         **/

        //Set Up Image
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        imageView.image = UIImage(named: "PlaceholderStudioImage")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)

        //Set Up TextView
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)
        //TODO: Use dynamic text
        textView.text = "Is this the real life? Is this just fantasy? Caught in a landslide, no escape from reality. Open your eyes, look up to the skies and see... I'm just a poor boy, I need no sympathy. Because I'm easy come, easy go. Little high, little low. Everywhere the wind blows doesn't really matter to me. To me..."
        let textViewSize = textView.sizeThatFits(CGSize(width: view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
        textView.frame = CGRect(x: 8, y: imageView.frame.maxY + 8, width: view.frame.width - 16, height: textViewSize.height)
        scrollView.addSubview(textView)

        //Set ScrollView content size
        scrollView.contentSize = CGSize(width: view.frame.width, height: textView.frame.maxY + 8)
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.errorMessage != nil {
            let parts = self.errorMessage!.components(separatedBy: ":")
            let alert = UIAlertController(title: parts[0], message: parts[1], preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func cancelLogin(segue:UIStoryboardSegue, sender:AnyObject) {
        if let origin = segue.source as? LoginVC {
            self.errorMessage = origin.errorMessage
        } else if let origin = segue.source as? AgreementVC {
            self.errorMessage = origin.errorMessage
        }

        if let username = UserDefaults.standard.string(forKey: "Username") {
            Messaging.messaging().unsubscribe(fromTopic: username)
        }
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        UserDefaults.standard.set(0, forKey: "DepartmentId")
        UserDefaults.standard.set(nil, forKey: "Name")
        UserDefaults.standard.set(nil, forKey: "Username")
        UserDefaults.standard.set(nil, forKey: "UserKey")
        UserDefaults.standard.set(0, forKey:"LoginSession")


    }
    
}

