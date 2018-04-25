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
    let refreshControl = UIRefreshControl()
    let imageView = UIImageView()
    let textView = UITextView()
    var refreshing = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)

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
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width / 16.0 * 9.0)
        //TODO: Use dynamic photo
        imageView.image = InventionStudioImages.imageForResource(group: "headers", name: "invention_studio")
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        scrollView.addSubview(imageView)
        
        //Set Up TextView
        
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.bounces = false
        textView.bouncesZoom = false
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont.systemFont(ofSize: 16)

        

        refresh(nil)
    }
    
    // updates the image and text view
    @objc func refresh(_ sender: Any?) {
        if (!refreshing) {
            refreshing = true
            
            SumsApi.EquipmentGroup.Info(completion: { info, error in
                if error != nil {
                    let parts = error!.components(separatedBy: ":")
                    self.alert(title: parts[0], message: parts[1], sender: sender)
                    self.refreshing = false
                    return
                }
                
                // updating image view
                self.imageView.image = InventionStudioImages.imageForResource(group: "headers", name: "invention_studio")
                
                //updating text view
                DispatchQueue.main.async {
                    let attributedString = try! NSMutableAttributedString(
                        data: info!.equipmentGroupDescriptionHtml.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                        options: [.documentType: NSAttributedString.DocumentType.html],
                        documentAttributes: nil)
                    let attributesDict = [NSAttributedStringKey.foregroundColor: Theme.text,
                                          NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
                    attributedString.addAttributes(attributesDict, range: NSMakeRange(0, attributedString.length))
                    self.textView.attributedText = attributedString
                    
                    let textViewSize = self.textView.sizeThatFits(CGSize(width: self.view.frame.width - 16, height: CGFloat.greatestFiniteMagnitude))
                    self.textView.frame = CGRect(x: 8, y: self.imageView.frame.maxY + 8, width: self.view.frame.width - 16, height: textViewSize.height)
                    self.scrollView.addSubview(self.textView)
                    
                    //Set ScrollView content size
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.textView.frame.maxY + 8)
                    
                    //Set up navigation bar
                    self.navigationItem.title = info!.equipmentGroupShortName
                    
                    // ending refreshing
                    if sender != nil {
                        let attributedTitle = NSAttributedString(string: "Last Refresh: Success")
                        (sender as! UIRefreshControl).attributedTitle = attributedTitle
                        (sender as! UIRefreshControl).endRefreshing()
                    }
                    self.refreshing = false
                }
            })
        }
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

    func alert(title: String, message: String, sender: Any?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: {
                if sender != nil {
                    let attributedTitle = NSAttributedString(string: "Last Refresh: Failed")
                    (sender as! UIRefreshControl).attributedTitle = attributedTitle
                    (sender as! UIRefreshControl).endRefreshing()
                }
            })
            
        }
    }
}

