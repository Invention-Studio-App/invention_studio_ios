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
        imageView.image = InventionStudioImages.imageForResource(group: "headers", name: "invention_studio")
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

        SumsApi.EquipmentGroup.Info(completion: { info in
            DispatchQueue.main.async {
                let attributedString = try! NSMutableAttributedString(
                    data: info.equipmentGroupDescriptionHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                    options: [.documentType: NSAttributedString.DocumentType.html],
                    documentAttributes: nil)
                let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                                      NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
                textView.attributedText = attributedString

                let textViewSize = textView.sizeThatFits(CGSize(width: self.view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
                textView.frame = CGRect(x: 8, y: imageView.frame.maxY + 8, width: self.view.frame.width - 16, height: textViewSize.height)
                self.scrollView.addSubview(textView)

                //Set ScrollView content size
                self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: textView.frame.maxY + 8)
            }
        })
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
            Messaging.messaging().unsubscribe(fromTopic: "\(username)_ios")
        }
        UserDefaults.standard.set(false, forKey: "LoggedIn")
        UserDefaults.standard.set(0, forKey: "DepartmentId")
        UserDefaults.standard.set(nil, forKey: "Name")
        UserDefaults.standard.set(nil, forKey: "Username")
        UserDefaults.standard.set(nil, forKey: "UserKey")
        UserDefaults.standard.set(0, forKey:"LoginSession")


    }
    
}

